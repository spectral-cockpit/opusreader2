# -*- coding: utf-8 -*-
"""
Created on Tue Jul 14 09:09:03 2015

@author: twagner
"""

### imports ###################################################################
import logging
import numpy as np
import struct

### logging ###################################################################
logging.getLogger('bruker_opus').addHandler(logging.NullHandler())

###############################################################################
class OpusReader(dict):
    def __init__(self, filename):
        self.logger = logging.getLogger('bruker_opus')
        
        self.opusFile = open(filename, 'rb')
        self.data = self.opusFile.read()
        self.opusFile.close()

        self.Nd = len(self.data)

        self.readHeader()

        self.dataBlockList = []
        self.parameterList = []

    def channel(self, block_key):
        parameter_key = ' '.join((block_key, 'Data Parameter'))
        NPT = self[parameter_key]['NPT']
        
        wn = self.wavenumber(block_key)
        data = self[block_key][:NPT]
        
        return wn, data

    def readHeader(self):
        Nh = 504
        self.header = self.data[0:Nh]

        self.offsetList = []
        self.chunkSizeList = []
        self.typeList = []
        self.channelList = []
        self.textList = []

        # cursor = 44
        cursor = 32
        
        while cursor > 0:
            i1 = cursor
            i2 = i1 + 4

            if i2 <= Nh:
                #%% read offset
                offset = struct.unpack('<I', self.header[i1:i2])[0]
                
                if offset > 0:
                    self.offsetList.append(offset)
                    
                    #%% read chunk size [4 bytes]
                    i1 = cursor - 4
                    i2 = i1 + 4
                    chunkSize = struct.unpack('<I', self.header[i1:i2])[0]
                    self.chunkSizeList.append(chunkSize)
                    
                    #%% read data type
                    i1 = cursor - 8
                    i2 = i1 + 1
                    value = struct.unpack('<B', self.header[i1:i2])[0]
                    self.typeList.append(value)

                    #%% read channel type
                    i1 = cursor - 7
                    i2 = i1 + 1
                    value = struct.unpack('<B', self.header[i1:i2])[0]
                    self.channelList.append(value)

                    #%% read text type
                    i1 = cursor - 6
                    i2 = i1 + 1
                    value = struct.unpack('<B', self.header[i1:i2])[0]
                    self.textList.append(value)

                    nextOffset = offset + 4 * chunkSize
                    
                    if nextOffset >= self.Nd:
                        # Next offset would reach EOF
                        cursor = -1
                    else:
                        cursor += 12
                else:
                    cursor = -1
            else:
                cursor = -1

        self.logger.debug("Offset: %s", self.offsetList)
        self.logger.debug("Chunk size: %s", self.chunkSizeList)
        
        self.logger.debug("Type: %s", self.typeList)
        self.logger.debug("Channel: %s", self.channelList)
        self.logger.debug("Text type: %s", self.textList)

        # print(self.typeList)
        # print(self.offsetList)
        # print(self.chunkSizeList)

    def readDataBlocks(self):
        Nb = len(self.offsetList)
        
        for iBlock in range(Nb):
            chunk = self.readChunk(iBlock)
            chunkSize = self.chunkSizeList[iBlock]
            blockType = self.typeList[iBlock]
            textType = self.textList[iBlock]
            channel = self.channelList[iBlock]
            
            dataBlock = DataBlock(
                chunk=chunk, chunkSize=chunkSize,
                blockType=blockType, textType=textType)
            
            self.dataBlockList.append(dataBlock)

            dataBlockName = None

            if blockType == 0:
                if textType == 8:
                    dataBlockName = 'Info Block'
                elif textType == 104:
                    dataBlockName = 'History'
                elif textType == 152:
                    dataBlockName = 'Curve Fit'
                elif textType == 168:
                    dataBlockName = 'Signature'
                elif textType == 240:
                    dataBlockName = 'Integration Method'
                else:
                    dataBlockName = 'Text Information'
                    
                self[dataBlockName] = dataBlock

            elif blockType == 7:
                if channel == 4:
                    self['ScSm'] = np.array(dataBlock.values)
                elif channel == 8:
                    self['IgSm'] = np.array(dataBlock.values)
                elif channel == 12:
                    self['PhSm'] = np.array(dataBlock.values)

            elif blockType == 11:
                if channel == 4:
                    self['ScRf'] = np.array(dataBlock.values)
                elif channel == 8:
                    self['IgRf'] = np.array(dataBlock.values)

            elif blockType == 15:
                self['AB'] = np.array(dataBlock.values)

            elif blockType == 23:
                if channel == 4:
                    dataBlockName = 'ScSm Data Parameter'
                elif channel == 8:
                    dataBlockName = 'IgSm Data Parameter'
                elif channel == 12:
                    dataBlockName = 'PhSm Data Parameter'

                self[dataBlockName] = dataBlock

            elif blockType == 27:
                if channel == 4:
                    dataBlockName = 'ScRf Data Parameter'
                elif channel == 8:
                    dataBlockName = 'IgRf Data Parameter'
                    
                self[dataBlockName] = dataBlock

            elif blockType == 31:
                dataBlockName = 'AB Data Parameter'
                self[dataBlockName] = dataBlock

            elif blockType == 32:
                dataBlockName = 'Instrument'
                self[dataBlockName] = dataBlock

            elif blockType == 40:
                dataBlockName = 'Instrument (Rf)'
                self[dataBlockName] = dataBlock

            elif blockType == 48:
                dataBlockName = 'Acquisition'
                self[dataBlockName] = dataBlock

            elif blockType == 56:
                dataBlockName = 'Acquisition (Rf)'
                self[dataBlockName] = dataBlock

            elif blockType == 64:
                dataBlockName = 'Fourier Transformation'
                self[dataBlockName] = dataBlock

            elif blockType == 72:
                dataBlockName = 'Fourier Transformation (Rf)'
                self[dataBlockName] = dataBlock

            elif blockType == 96:
                dataBlockName = 'Optik'
                self[dataBlockName] = dataBlock

            elif blockType == 104:
                dataBlockName = 'Optik (Rf)'
                self[dataBlockName] = dataBlock

            elif blockType == 160:
                dataBlockName = 'Sample'
                self[dataBlockName] = dataBlock

            else:
                self.logger.error(
                    'block type %s not implemented yet', blockType
                )

            if dataBlockName is not None:                
                parameter = {'name': dataBlockName, 'type': 'group'}
                parameter['children'] = dataBlock.parameterList
                
                self.parameterList.append(parameter)

        '''
        if 'IgRf Data Parameter' in self.keys():
            fxv = self['IgRf Data Parameter']['FXV']
            lxv = self['IgRf Data Parameter']['LXV']
            npt = self['IgRf Data Parameter']['NPT']
            self['WN'] = np.linspace(fxv, lxv, npt)
        if 'IgSm Data Parameter' in self.keys():
            fxv = self['IgSm Data Parameter']['FXV']
            lxv = self['IgSm Data Parameter']['LXV']
            npt = self['IgSm Data Parameter']['NPT']
            self['WN'] = np.linspace(fxv, lxv, npt)
        if 'AB Data Parameter' in self.keys():
            fxv = self['AB Data Parameter']['FXV']
            lxv = self['AB Data Parameter']['LXV']
            npt = self['AB Data Parameter']['NPT']
            self['WN'] = np.linspace(fxv, lxv, npt)
    
            self.AB = Absorption(wavenumber = wavenumber, AB = self['AB'])
        '''
        
    def readChunk(self, iBlock):
        i1 = self.offsetList[iBlock]
        i2 = i1 + 4 * self.chunkSizeList[iBlock]
        
        chunk = self.data[i1:i2]
        
        return chunk

    def wavenumber(self, block_key):
        parameter_key = ' '.join((block_key, 'Data Parameter'))
        FXV = self[parameter_key]['FXV']
        LXV = self[parameter_key]['LXV']
        NPT = self[parameter_key]['NPT']

        wn = np.linspace(FXV, LXV, NPT)        

        return wn
    
###############################################################################
class DataBlock(dict):
    def __init__(self, **kwargs):
        self.logger = logging.getLogger('bruker_opus')

        self.textType = -1
        
        for key, value in kwargs.items():
            if key == "chunk":
                self.chunk = value
            elif key == "chunkSize":
                self.chunkSize = value
            elif key == "blockType":
                self.blockType = value
            elif key == "blockType":
                self.blockType = value
            elif key == "textType":
                self.textType = value

        self.parameterList = []

        self.readChunk()


    def readChunk(self):
        if self.blockType == 0:
            if self.textType == 8:
                # INFO
                self.readParameter()
            else:
                # datafile history
                self.readText()
        elif self.blockType == 7:
            # ScSm
            self.readData()
        elif self.blockType == 11:
            # ScRf
            self.readData()
        elif self.blockType == 15:
            # AB
            self.readData()
        elif self.blockType in [23, 27, 31, 32, 40, 48, 64, 96, 104, 160]:
            self.readParameter()
        else:
            self.logger.warning("Unknown data block type %i", self.blockType)
            self.readParameter()
            
    
    def readParameter(self):
        cursor = 0
        parameterName = ''
        parameterType = ''
        self.parameterTypes = ['int', 'float', 'str', 'str', 'str']

        while cursor >= 0:        
            i1 = cursor
            i2 = i1 + 3

            try:
                parameterName = self.chunk[i1:i2].decode("utf-8")
            except:
                self.logger.error(
                    "Could not decode chunk %s", self.chunk[i1:i2]
                )

            if parameterName == 'END':
                cursor = -1
                return


            # read parameter type
            i1 = cursor + 4
            i2 = i1 + 2
            
            try:
                typeIndex = struct.unpack('<H', self.chunk[i1:i2])[0]
            except:
                self.logger.error('Could not unpack from %s', self.chunk[i1:i2])
                cursor = -1
                return

            try:
                parameterType = self.parameterTypes[typeIndex]
            except IndexError:
                self.logger.error(
                    "type index: %i, chunk length: %i",
                    typeIndex,
                    len(self.chunk)
                )
    
            # read parameter size
            i1 = cursor + 6
            i2 = i1 + 2
            parameterSize = struct.unpack('<H', self.chunk[i1:i2])[0]
    
            # read value
            i1 = cursor + 8
            i2 = i1 + 2 * parameterSize
            value = self.chunk[i1:i2]

            if typeIndex == 0:
                try:
                    parameterValue = struct.unpack('<i', value)[0]
                except:
                    self.logger.error('Could not unpack %s', value)
                    cursor = -1
                    return
            elif typeIndex == 1:
                # unpack little-endinan double
                parameterValue = struct.unpack('<d', value)[0]
            elif typeIndex == 2:
                iEnd = value.find(b'\x00')
                parameterValue = value[:iEnd].decode("latin-1")
            elif typeIndex == 3:
                iEnd = value.find(b'\x00')
                parameterValue = value[:iEnd].decode("latin-1")
            elif typeIndex == 4:
                iEnd = value.find(b'\x00')
                parameterValue = value[:iEnd].decode("latin-1")
                
            else:
                parameterValue = value

            self[parameterName] = parameterValue

            parameter = {}
            parameter['name'] = parameterName
            parameter['value'] = parameterValue
            parameter['type'] = parameterType
            self.parameterList.append(parameter)

            self.logger.debug(
                '%s %s %s %s %s',
                parameterName, typeIndex, parameterType, parameterSize,
                parameterValue
            )
    
            cursor = cursor + 8 + 2 * parameterSize


    def readData(self):
        fmt = '<' + str(self.chunkSize) + 'f'
        self.values = struct.unpack(fmt, self.chunk)

        self.logger.debug(self.values)

    def readText(self):
        self.text = self.chunk.decode('latin-1')

    def readInfo(self):
        cursor = 0
        parameterName = ''
        parameterType = ''
        self.parameterTypes = ['int', 'float', 'str', 'str', 'str']
        
        while cursor >= 0:
            i1 = cursor
            i2 = i1 + 3
            
            try:
                parameterName = self.chunk[i1:i2].decode("utf-8")
            except:
                self.logger.error(
                    "Could not decode chunk %s", self.chunk[i1:i2]
                )

            if parameterName == 'END':
                cursor = -1
                return

            # read parameter type
            i1 = cursor + 4
            i2 = i1 + 2
            typeIndex = struct.unpack('<H', self.chunk[i1:i2])[0]

            try:
                parameterType = self.parameterTypes[typeIndex]
            except IndexError:
                self.logger.error(
                    "type index: %i, chunk length: %i",
                    typeIndex,
                    len(self.chunk)
                )

            # read parameter size
            i1 = cursor + 6
            i2 = i1 + 2
            parameterSize = struct.unpack('<H', self.chunk[i1:i2])[0]
    
            # read value
            i1 = cursor + 8
            i2 = i1 + 2 * parameterSize
            value = self.chunk[i1:i2]

            if typeIndex == 0:
                parameterValue = struct.unpack('<i', value)[0]
            elif typeIndex == 1:
                # unpack little-endinan double
                parameterValue = struct.unpack('<d', value)[0]
            elif typeIndex == 2:
                iEnd = value.find(b'\x00')
                parameterValue = value[:iEnd].decode("latin-1")
            elif typeIndex == 3:
                iEnd = value.find(b'\x00')
                parameterValue = value[:iEnd].decode("latin-1")
            elif typeIndex == 4:
                iEnd = value.find(b'\x00')
                parameterValue = value[:iEnd].decode("latin-1")
                
            else:
                parameterValue = value

            self[parameterName] = parameterValue

            parameter = {}
            parameter['name'] = parameterName
            parameter['value'] = parameterValue
            parameter['type'] = parameterType
            self.parameterList.append(parameter)

            self.logger.debug(
                '%s %s %s %s %s',
                parameterName, typeIndex, parameterType, parameterSize,
                parameterValue
            )
    
            cursor = cursor + 8 + 2 * parameterSize
