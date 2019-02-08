# sfunctional
a functional library for swift(ios).

#### Using in iOS

```
source 'https://github.com/rarnu/RarnuSpecs.git'

... ...

use_frameworks!
pod 'sfunctional'
```

#### Try this

```
thread {
    // do something in a sub thread
    self.mainThread {
        // do something in main thread
    }
    // do something in a sub thread
}

var dt = Data() as Any
fileIO(src: "try1", dest: dt, isSrcText: true) { (succ, data, error) in
    dt = data as! Data
    let s = String(data: dt as! Data, encoding: .utf8)
    print(s!)
}

http(url, method: "POST", postParam: ["a":"avar", "b":"bvar", "c":"cvar"]) { (_ code: Int, _ result: String?, _ error: String?) in
    print(code)
    print(result!)
}

download(url, documentPath(true) + "a.png") { (state, position, fileSize, error) in
    print("\(state), \(position), \(fileSize)")
    if (state == DownloadState.Error) {
        print("Download Error => \(error!)")
    }
}
```
