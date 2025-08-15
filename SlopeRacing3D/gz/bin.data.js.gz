
  if (!Module.expectedDataFileDownloads) {
    Module.expectedDataFileDownloads = 0;
  }

  Module.expectedDataFileDownloads++;
  (function() {
    // When running as a pthread, FS operations are proxied to the main thread, so we don't need to
    // fetch the .data bundle on the worker
    if (Module['ENVIRONMENT_IS_PTHREAD']) return;
    var loadPackage = function(metadata) {

      var PACKAGE_PATH = '';
      if (typeof window === 'object') {
        PACKAGE_PATH = window['encodeURIComponent'](window.location.pathname.toString().substring(0, window.location.pathname.toString().lastIndexOf('/')) + '/');
      } else if (typeof process === 'undefined' && typeof location !== 'undefined') {
        // web worker
        PACKAGE_PATH = encodeURIComponent(location.pathname.toString().substring(0, location.pathname.toString().lastIndexOf('/')) + '/');
      }
      var PACKAGE_NAME = 'bin.data._.js';
      var REMOTE_PACKAGE_BASE = 'bin.data._.js';
      if (typeof Module['locateFilePackage'] === 'function' && !Module['locateFile']) {
        Module['locateFile'] = Module['locateFilePackage'];
        err('warning: you defined Module.locateFilePackage, that has been renamed to Module.locateFile (using your locateFilePackage for now)');
      }
      var REMOTE_PACKAGE_NAME = Module['locateFile'] ? Module['locateFile'](REMOTE_PACKAGE_BASE, '') : REMOTE_PACKAGE_BASE;

      var REMOTE_PACKAGE_SIZE = metadata['remote_package_size'];
      var PACKAGE_UUID = metadata['package_uuid'];

      function fetchRemotePackage(packageName, packageSize, callback, errback) {
        if (typeof process === 'object' && typeof process.versions === 'object' && typeof process.versions.node === 'string') {
          require('fs').readFile(packageName, function(err, contents) {
            if (err) {
              errback(err);
            } else {
              callback(contents.buffer);
            }
          });
          return;
        }
        var xhr = new XMLHttpRequest();
        xhr.open('GET', packageName, true);
        xhr.responseType = 'arraybuffer';
        xhr.onprogress = function(event) {
          var url = packageName;
          var size = packageSize;
          if (event.total) size = event.total;
          if (event.loaded) {
            if (!xhr.addedTotal) {
              xhr.addedTotal = true;
              if (!Module.dataFileDownloads) Module.dataFileDownloads = {};
              Module.dataFileDownloads[url] = {
                loaded: event.loaded,
                total: size
              };
            } else {
              Module.dataFileDownloads[url].loaded = event.loaded;
            }
            var total = 0;
            var loaded = 0;
            var num = 0;
            for (var download in Module.dataFileDownloads) {
            var data = Module.dataFileDownloads[download];
              total += data.total;
              loaded += data.loaded;
              num++;
            }
            total = Math.ceil(total * Module.expectedDataFileDownloads/num);
            if (Module['setStatus']) Module['setStatus']('Downloading data... (' + loaded + '/' + total + ')');
          } else if (!Module.dataFileDownloads) {
            if (Module['setStatus']) Module['setStatus']('Downloading data...');
          }
        };
        xhr.onerror = function(event) {
          throw new Error("NetworkError for: " + packageName);
        }
        xhr.onload = function(event) {
          if (xhr.status == 200 || xhr.status == 304 || xhr.status == 206 || (xhr.status == 0 && xhr.response)) { // file URLs can return 0
            var packageData = xhr.response;
            callback(packageData);
          } else {
            throw new Error(xhr.statusText + " : " + xhr.responseURL);
          }
        };
        xhr.send(null);
      };

      function handleError(error) {
        console.error('package error:', error);
      };

      var fetchedCallback = null;
      var fetched = Module['getPreloadedPackage'] ? Module['getPreloadedPackage'](REMOTE_PACKAGE_NAME, REMOTE_PACKAGE_SIZE) : null;

      if (!fetched) fetchRemotePackage(REMOTE_PACKAGE_NAME, REMOTE_PACKAGE_SIZE, function(data) {
        if (fetchedCallback) {
          fetchedCallback(data);
          fetchedCallback = null;
        } else {
          fetched = data;
        }
      }, handleError);

    function runWithFS() {

      function assert(check, msg) {
        if (!check) throw msg + new Error().stack;
      }
Module['FS_createPath']("/", "textures", true, true);
Module['FS_createPath']("/", "Managed", true, true);
Module['FS_createPath']("/Managed", "mono", true, true);
Module['FS_createPath']("/Managed/mono", "4.0", true, true);
Module['FS_createPath']("/", "Il2CppData", true, true);
Module['FS_createPath']("/Il2CppData", "Metadata", true, true);
Module['FS_createPath']("/", "Resources", true, true);

      /** @constructor */
      function DataRequest(start, end, audio) {
        this.start = start;
        this.end = end;
        this.audio = audio;
      }
      DataRequest.prototype = {
        requests: {},
        open: function(mode, name) {
          this.name = name;
          this.requests[name] = this;
          Module['addRunDependency']('fp ' + this.name);
        },
        send: function() {},
        onload: function() {
          var byteArray = this.byteArray.subarray(this.start, this.end);
          this.finish(byteArray);
        },
        finish: function(byteArray) {
          var that = this;
          // canOwn this data in the filesystem, it is a slide into the heap that will never change
          Module['FS_createDataFile'](this.name, null, byteArray, true, true, true);
          Module['removeRunDependency']('fp ' + that.name);
          this.requests[this.name] = null;
        }
      };

      var files = metadata['files'];
      for (var i = 0; i < files.length; ++i) {
        new DataRequest(files[i]['start'], files[i]['end'], files[i]['audio'] || 0).open('GET', files[i]['filename']);
      }

      function processPackageData(arrayBuffer) {
        assert(arrayBuffer, 'Loading data file failed.');
        assert(arrayBuffer instanceof ArrayBuffer, 'bad input to processPackageData');
        var byteArray = new Uint8Array(arrayBuffer);
        var curr;
        // Reuse the bytearray from the XHR as the source for file reads.
          DataRequest.prototype.byteArray = byteArray;
          var files = metadata['files'];
          for (var i = 0; i < files.length; ++i) {
            DataRequest.prototype.requests[files[i].filename].onload();
          }          Module['removeRunDependency']('datafile_bin.data._.js');

      };
      Module['addRunDependency']('datafile_bin.data._.js');

      if (!Module.preloadResults) Module.preloadResults = {};

      Module.preloadResults[PACKAGE_NAME] = {fromCache: false};
      if (fetched) {
        processPackageData(fetched);
        fetched = null;
      } else {
        fetchedCallback = processPackageData;
      }

    }
    if (Module['calledRun']) {
      runWithFS();
    } else {
      if (!Module['preRun']) Module['preRun'] = [];
      Module["preRun"].push(runWithFS); // FS is not initialized yet, wait for it
    }

    }
    loadPackage({"files": [{"filename": "/boot.config", "start": 0, "end": 49}, {"filename": "/RuntimeInitializeOnLoads.json", "start": 49, "end": 219}, {"filename": "/level0", "start": 219, "end": 88919}, {"filename": "/globalgamemanagers.assets", "start": 88919, "end": 127843}, {"filename": "/ScriptingAssemblies.json", "start": 127843, "end": 130369}, {"filename": "/sharedassets0.assets", "start": 130369, "end": 890845}, {"filename": "/globalgamemanagers", "start": 890845, "end": 926793}, {"filename": "/gpx.audio", "start": 926793, "end": 926793}, {"filename": "/gpx.resources", "start": 926793, "end": 931521}, {"filename": "/textures/253737fc989ad49ea619eec91a8d9409.png", "start": 931521, "end": 931714}, {"filename": "/textures/127af9c791fc66b799006105782a5cc7.png", "start": 931714, "end": 934693}, {"filename": "/textures/aeace3e64256b4295a307643cf35c91c.png", "start": 934693, "end": 946428}, {"filename": "/textures/fa22d7a36ff88ad130139ed4eea1c260.png", "start": 946428, "end": 949229}, {"filename": "/textures/fad9a48b7bec21aaa79672dee0cbcaa9.png", "start": 949229, "end": 949424}, {"filename": "/textures/ab515dc584c9f917de32e801faf9d42d.png", "start": 949424, "end": 949721}, {"filename": "/textures/11eb8f140347b267dc123fd1a1cfd1d6.png", "start": 949721, "end": 950980}, {"filename": "/textures/7d3824f1725636e27e40b10766396991.png", "start": 950980, "end": 952013}, {"filename": "/textures/07b09dcc8a8d5404d5f1dc36172566fa.png", "start": 952013, "end": 952212}, {"filename": "/textures/b73b793a2835b3745344282ed3e5bb44.png", "start": 952212, "end": 953877}, {"filename": "/textures/762810b33a952ce3fc0dc2a414127671.png", "start": 953877, "end": 958580}, {"filename": "/textures/a720d309face46e2c904594d2cfd07b4.png", "start": 958580, "end": 966491}, {"filename": "/textures/163e494484b3df30e46b2ce11dc02af0.png", "start": 966491, "end": 971724}, {"filename": "/textures/54af7c3a4a23a993f976e525262198af.png", "start": 971724, "end": 971853}, {"filename": "/textures/3d9db6d341885b13b1270d29168f1101.png", "start": 971853, "end": 972096}, {"filename": "/textures/bcb068db0eebbe9a2603973f4a72e650.png", "start": 972096, "end": 973217}, {"filename": "/textures/22a7b31414d45eca6c910f17fd73e746.png", "start": 973217, "end": 973484}, {"filename": "/textures/b73919a6b478fb575098d26428598484.png", "start": 973484, "end": 978565}, {"filename": "/textures/fe15605fca2f0fd5d3f56ae013b031ec.png", "start": 978565, "end": 978764}, {"filename": "/textures/c2b92244a0b5e569063fe94782b83805.png", "start": 978764, "end": 979629}, {"filename": "/textures/34f7f86825e165c9615c5de0a51101a8.png", "start": 979629, "end": 979836}, {"filename": "/textures/c8068216edabb9018d23875967a5e8eb.png", "start": 979836, "end": 980035}, {"filename": "/textures/1db6df0ae303f823215dc07d0a29f21d.png", "start": 980035, "end": 988596}, {"filename": "/textures/1954953e457361d89856c13d324f6764.png", "start": 988596, "end": 999699}, {"filename": "/textures/a669d21b856fad47e3d047528bde48cd.png", "start": 999699, "end": 999970}, {"filename": "/textures/7494ba69c9b18e9b56b3a42447e7c047.png", "start": 999970, "end": 1005159}, {"filename": "/textures/387c736dde3bda106e4dec53d54a6bb3.png", "start": 1005159, "end": 1010250}, {"filename": "/textures/0235f3b373012723020ec48b13e6aabc.png", "start": 1010250, "end": 1017965}, {"filename": "/textures/591845a8c488027045aa350707f32328.png", "start": 1017965, "end": 1018102}, {"filename": "/textures/d66a9b90a914d41cb036542d51b8e99f.png", "start": 1018102, "end": 1018267}, {"filename": "/textures/0323d4622c833117bc680bc3aa915515.png", "start": 1018267, "end": 1020852}, {"filename": "/textures/65d5abb5be486ac4e8c9c02e518b9918.png", "start": 1020852, "end": 1022257}, {"filename": "/textures/b03863150b0b623fdcf5a384c55d30e3.png", "start": 1022257, "end": 1025860}, {"filename": "/textures/7fc28de3ba793dcf5c0ff7f3d1c1b834.png", "start": 1025860, "end": 1026061}, {"filename": "/textures/d19e223f5698cfb4ff9ef2b6b0cb797f.png", "start": 1026061, "end": 1029688}, {"filename": "/textures/2736e8bc899e907517853cc3739f669c.png", "start": 1029688, "end": 1029815}, {"filename": "/textures/91457a17c9cf3e425da708e8f62efcbc.png", "start": 1029815, "end": 1029984}, {"filename": "/textures/1d6311f88d0eec7f796583c003331e36.png", "start": 1029984, "end": 1030855}, {"filename": "/textures/a42557530f88e02aac9aff8c9ba0191c.png", "start": 1030855, "end": 1036094}, {"filename": "/textures/b5f69e82deb574a762968b05e6424c63.png", "start": 1036094, "end": 1037621}, {"filename": "/textures/3beb9024bd9196f0df90601a833f75b0.png", "start": 1037621, "end": 1037934}, {"filename": "/textures/2674379d564ed23985e4d1b4e366d72f.png", "start": 1037934, "end": 1038217}, {"filename": "/textures/e708323e2ee90f9d296566ab5fde81d0.png", "start": 1038217, "end": 1039830}, {"filename": "/textures/9999ba253411b30f30f33fb360dab1e3.png", "start": 1039830, "end": 1040041}, {"filename": "/textures/853839dc22807dc031cb865fae9bdb06.png", "start": 1040041, "end": 1043652}, {"filename": "/textures/3b7e6498c3c9db5e744fcbe57580b0cd.png", "start": 1043652, "end": 1043943}, {"filename": "/textures/7593e8fe8c1058774d6ae36e969fc093.png", "start": 1043943, "end": 1045122}, {"filename": "/textures/4bfe53567dc45f5a28431018c43566b4.png", "start": 1045122, "end": 1046259}, {"filename": "/textures/21cb8f899e3f8ada6cd0c2743d56ea97.png", "start": 1046259, "end": 1047122}, {"filename": "/textures/dc31bf80c2ea93af223b910f5afd7d1d.png", "start": 1047122, "end": 1047367}, {"filename": "/textures/6f49f0364594331cf64f42d1c4a70492.png", "start": 1047367, "end": 1049848}, {"filename": "/textures/5f3f15b43efcb03367eecaab6ba820f6.png", "start": 1049848, "end": 1054877}, {"filename": "/textures/86893bc25ca0e43a7273da9fa57173b3.png", "start": 1054877, "end": 1055028}, {"filename": "/textures/d1cdbbe0c16aff9b693d261b66e1d630.png", "start": 1055028, "end": 1055243}, {"filename": "/textures/d11824a5bbc4538e17e1d127f7d3363b.png", "start": 1055243, "end": 1057146}, {"filename": "/textures/b52040072b1bb053237641bea612420b.png", "start": 1057146, "end": 1062369}, {"filename": "/textures/39a14ee6b2de862a7627e85f6436be22.png", "start": 1062369, "end": 1062570}, {"filename": "/textures/3b6735371dbf4abf08f0e6a79d5bb9c0.png", "start": 1062570, "end": 1063619}, {"filename": "/textures/2e45e86190ccb177a281ae5a951816f8.png", "start": 1063619, "end": 1063816}, {"filename": "/textures/647aa2afd1c690949beaccac239dcdc0.png", "start": 1063816, "end": 1064043}, {"filename": "/textures/69d58ba7c15aedb7bec58d84826293aa.png", "start": 1064043, "end": 1064244}, {"filename": "/textures/e56cf490437aac3cd4b8f5c68b0b66e2.png", "start": 1064244, "end": 1069235}, {"filename": "/textures/0613f84493a779e0fdf2c4654258822d.png", "start": 1069235, "end": 1069424}, {"filename": "/textures/b1fd4a07b3a9eaffc46765bb62591dc6.png", "start": 1069424, "end": 1069505}, {"filename": "/textures/3b318b6ad661176e926958d4be0842fb.png", "start": 1069505, "end": 1069682}, {"filename": "/Managed/mono/4.0/machine.config", "start": 1069682, "end": 1103330}, {"filename": "/Il2CppData/Metadata/global-metadata.dat", "start": 1103330, "end": 2693626}, {"filename": "/Resources/unity_default_resources", "start": 2693626, "end": 3207334}, {"filename": "/Resources/unity_builtin_extra", "start": 3207334, "end": 3668934}], "remote_package_size": 3668934, "package_uuid": "ed7574c6-dd90-4d8a-9f79-9ccf81ae582e"});

  })();
