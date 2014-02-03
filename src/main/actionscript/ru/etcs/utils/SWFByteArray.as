/**
 * FontLoader 2.3 by Denis Kolyako. June 13, 2008. Last update: February 03, 2014.
 * Visit http://etcs.ru for documentation, updates and more free code.
 *
 * You may distribute this class freely, provided it is not modified in any way (including
 * removing this header or changing the package path).
 *
 *
 * Please contact etc[at]mail.ru prior to distributing modified versions of this class.
 */
package ru.etcs.utils {
import flash.geom.Rectangle;
import flash.utils.ByteArray;
import flash.utils.Endian;

/**
 * TBD
 */
public class SWFByteArray extends ByteArray {
    //----------------------------------
    //  Static properties
    //----------------------------------

    /**
     * @private
     */
    private static const TAG_SWF:String = 'FWS';

    /**
     * @private
     */
    private static const TAG_SWF_ZLIB:String = 'CWS';

    /**
     * @private
     */
    private static const TAG_SWF_LZMA:String = 'ZWS';

    //----------------------------------
    //  Private properties
    //----------------------------------

    /**
     * @private
     */
    private var _bitIndex:uint;

    /**
     * @private
     */
    private var _version:uint;

    /**
     * @private
     */
    private var _frameRate:Number;

    /**
     * @private
     */
    private var _rect:Rectangle;

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * TBD
     */
    public function SWFByteArray(data:ByteArray = null):void {
        super();
        super.endian = Endian.LITTLE_ENDIAN;
        var endian:String;
        var tag:String;
        var position:uint;

        if (data) {
            endian = data.endian;
            position = data.position;
            data.endian = Endian.LITTLE_ENDIAN;
            data.position = 0;

            if (data.bytesAvailable > 26) {
                tag = data.readUTFBytes(3);

                if (tag == TAG_SWF || tag == TAG_SWF_ZLIB || tag == TAG_SWF_LZMA) {
                    this._version = data.readUnsignedByte();
                    data.readUnsignedInt();
                    data.readBytes(this);
                    if (tag == TAG_SWF_ZLIB) super.uncompress();
                } else throw new ArgumentError('Error #2124: Loaded file is an unknown type.');

                this.readHeader();
            } else {
                throw new ArgumentError('Insufficient data.');
            }

            data.endian = endian;
            data.position = position;
        }
    }

    //----------------------------------
    //  Getters
    //----------------------------------

    /**
     * TBD
     */
    public function get version():uint {
        return this._version;
    }

    /**
     * TBD
     */
    public function get frameRate():Number {
        return this._frameRate;
    }


    /**
     * TBD
     */
    public function get rect():Rectangle {
        return this._rect;
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * TBD
     */
    public function writeBytesFromString(bytesHexString:String):void {
        var length:uint = bytesHexString.length;

        for (var i:uint = 0; i < length; i += 2) {
            var hexByte:String = bytesHexString.substr(i, 2);
            var byte:uint = parseInt(hexByte, 16);
            writeByte(byte);
        }
    }

    /**
     * TBD
     */
    public function readRect():Rectangle {
        var pos:uint = super.position;
        var byte:uint = this[pos];
        var bits:uint = byte >> 3;
        var xMin:Number = this.readBits(bits, 5) / 20;
        var xMax:Number = this.readBits(bits) / 20;
        var yMin:Number = this.readBits(bits) / 20;
        var yMax:Number = this.readBits(bits) / 20;
        super.position = pos + Math.ceil(((bits * 4) - 3) / 8) + 1;
        return new Rectangle(xMin, yMin, xMax - xMin, yMax - yMin);
    }

    /**
     * TBD
     */
    public function readBits(length:uint, start:int = -1):Number {
        if (start < 0) start = this._bitIndex;
        this._bitIndex = start;
        var byte:uint = this[super.position];
        var out:Number = 0;
        var shift:Number = 0;
        var currentByteBitsLeft:uint = 8 - start;
        var bitsLeft:Number = length - currentByteBitsLeft;

        if (bitsLeft > 0) {
            super.position++;
            out = this.readBits(bitsLeft, 0) | ((byte & ((1 << currentByteBitsLeft) - 1)) << (bitsLeft));
        } else {
            out = (byte >> (8 - length - start)) & ((1 << length) - 1);
            this._bitIndex = (start + length) % 8;
            if (start + length > 7) super.position++;
        }

        return out;
    }

    //----------------------------------
    //  Helpers
    //----------------------------------

    /**
     * @private
     */
    private function readFrameRate():void {
        if (this._version < 8) {
            this._frameRate = super.readUnsignedShort();
        } else {
            var fixed:Number = super.readUnsignedByte() / 0xFF;
            this._frameRate = super.readUnsignedByte() + fixed;
        }
    }

    /**
     * @private
     */
    private function readHeader():void {
        this._rect = this.readRect();
        this.readFrameRate();
        super.readShort(); // num of frames
    }
}
}
