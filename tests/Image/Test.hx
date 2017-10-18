
    #if (!mac && !android && !ios && !linux && !windows)
        #error "You should define a target, please read and modify build.hxml"
    #end

class Test {

    static function main() {

        test_memory();
        test_files();
        test_hdr();

    } //main

    static function test_memory() {

        trace('------- FROM MEMORY');

        var bytes = haxe.Resource.getBytes('image.png');

        inline function test_memory_info() {

            var info = stb.Image.info_from_memory(bytes.getData(), bytes.length);
            print_image_info('memory@image.png', info);
            info = null;

        } //test_memory_info

        inline function test_memory_data() {

            var data = stb.Image.load_from_memory(bytes.getData(), bytes.length);
            print_image_data('memory@image.png', data);
            data = null;

        } //test_memory_data

        test_memory_info();
        test_memory_data();

    } //test_memory

    static function test_files() {

        trace('------- FROM FILES');

        var file_prefix = './';
        var files = [
            'image.png',
            'image.gif',
            'image.tga',
            'image.jpg',
            'image.bmp',
            'image.psd',
            'image.hdr',
        ];

        inline function test_file_data(req_comp:Int) {

            for(file in files) {
                var data = stb.Image.load(haxe.io.Path.join([file_prefix,file]), req_comp);
                if(data == null) {
                    trace('FAIL: DATA: $file / ' + stb.Image.failure_reason());
                } else {
                    print_image_data(file, data);
                }
                data = null;
            }

        } //test_file_data

        inline function test_file_info() {
            for(file in files) {
                var info = stb.Image.info(haxe.io.Path.join([file_prefix,file]));
                if(info == null) {
                    trace('FAIL: INFO: $file / ' + stb.Image.failure_reason());
                } else {
                    print_image_info(file, info);
                }
                info = null;
            }
        } //test_file_info

        test_file_info();
        test_file_data(4); 
        test_file_data(0); // tests default value case

    } //test_files

    static function print_image_data(file:String, image:stb.Image.StbImageData) {

        trace('DATA:  $file ${image.w} x ${image.h} comp:${image.comp} req_comp:${image.comp} / ${image.bytes.length} bytes');

        var s = '';

        for(i in 0 ... image.w) {
            for(j in 0 ... image.comp) s += ' ${image.bytes[i*j]}';
            if(i < image.w-1) s += ' /';
        }

        trace(s);

    } //print_image_data

    static function print_image_data_float(file:String, image:stb.Image.StbImageData) {

        trace('DATA:  $file ${image.w} x ${image.h} comp:${image.comp} req_comp:${image.comp} / ${image.bytes.length} bytes');

        var s = '';

        var bytes = haxe.io.Bytes.ofData(image.bytes);
        var floats = haxe.io.Float32Array.fromBytes(bytes);

        var len = image.w * image.h;

        for(i in 0 ... len) {
            for(j in 0 ... image.comp) s += ' ${floats[i*image.comp + j]}';
            if(i < len-1) s += ' /';
        }

        trace(s);

    } //print_image_data

    static function print_image_info(file:String, image:stb.Image.StbImageInfo) {

        trace('INFO:  $file ${image.w} x ${image.h} comp:${image.comp}');

    } //print_image_info

    static function test_hdr() {

        trace('------- FROM HDR');

        var file_prefix = './';
        var files = [
            'image.hdr'
        ];

        inline function test_file_data(req_comp:Int) {

            for(file in files) {
                var data = stb.Image.loadf(haxe.io.Path.join([file_prefix,file]), req_comp);
                if(data == null) {
                    trace('FAIL: DATA: $file / ' + stb.Image.failure_reason());
                } else {
                    print_image_data_float(file, data);
                }
                data = null;
            }

        } //test_file_data

        inline function test_file_info() {
            for(file in files) {
                var info = stb.Image.info(haxe.io.Path.join([file_prefix,file]));
                if(info == null) {
                    trace('FAIL: INFO: $file / ' + stb.Image.failure_reason());
                } else {
                    print_image_info(file, info);
                }
                info = null;
            }
        } //test_file_info

        test_file_info();
        test_file_data(0); // tests default value case

    } //test_files

} //Test
