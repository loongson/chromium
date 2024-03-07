+#! /bin/bash
+
+# Chromium build configuration description.
+# Author: Wang Qing <wangqing-hf@loongson.cn>
+
+# Set gn args to build.
+export GN_CONFIG=(
+'google_api_key="AIzaSyDxKL42zsPjbke5O8_rPVpVrLrJ8aeE9rQ"'
+'google_default_client_id="595013732528-llk8trb03f0ldpqq6nprjp1s79596646.apps.googleusercontent.com"'
+'google_default_client_secret="5ntt6GbbkjnTVXx-MSxbmx5e"'
+'enable_hangout_services_extension=true'
+'enable_nacl=false'
+'enable_swiftshader=false'
+'angle_enable_swiftshader=false'
+'enable_swiftshader_vulkan=false'
+'enable_widevine=false'
+'fatal_linker_warnings=false'
+'disable_fieldtrial_testing_config=true'
+'ffmpeg_branding="Chrome"'
+'is_debug=false'
+'use_gold=false'
+'is_clang=true'
+'clang_use_chrome_plugins=false'
+'link_pulseaudio=true'
+'proprietary_codecs=true'
+'symbol_level=0'
+'treat_warnings_as_errors=false'
+'use_allocator="partition"'
+'use_cups=true'
+'use_gnome_keyring=false'
+'use_kerberos=true'
+'use_pulseaudio=true'
+'use_sysroot=true'
+'rtc_include_dav1d_in_internal_decoder_factory=false'
+'host_cpu = "x64"'
+'target_cpu = "loong64"'
+'v8_target_cpu = "loong64"'
+'rtc_use_pipewire=false'
+'enable_libaom=false')
+
+# Set build directory.
+root_build_dir="out/la64_cross"
+
+# generate root_build_dir to build.
+./buildtools/linux64/gn gen $root_build_dir --args="${GN_CONFIG[*]}"
