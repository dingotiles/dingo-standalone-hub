// Code generated by go-bindata.
// sources:
// data/tutorial/docker-host-ip-docker-machine.txt
// data/tutorial/docker-host-ip-dockermac.txt
// data/tutorial/docker-run-5000.txt
// data/tutorial/get-started.txt
// data/tutorial/show-usage.txt
// DO NOT EDIT!

package main

import (
	"bytes"
	"compress/gzip"
	"fmt"
	"io"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"
	"time"
)

func bindataRead(data []byte, name string) ([]byte, error) {
	gz, err := gzip.NewReader(bytes.NewBuffer(data))
	if err != nil {
		return nil, fmt.Errorf("Read %q: %v", name, err)
	}

	var buf bytes.Buffer
	_, err = io.Copy(&buf, gz)
	clErr := gz.Close()

	if err != nil {
		return nil, fmt.Errorf("Read %q: %v", name, err)
	}
	if clErr != nil {
		return nil, err
	}

	return buf.Bytes(), nil
}

type asset struct {
	bytes []byte
	info  os.FileInfo
}

type bindataFileInfo struct {
	name    string
	size    int64
	mode    os.FileMode
	modTime time.Time
}

func (fi bindataFileInfo) Name() string {
	return fi.name
}
func (fi bindataFileInfo) Size() int64 {
	return fi.size
}
func (fi bindataFileInfo) Mode() os.FileMode {
	return fi.mode
}
func (fi bindataFileInfo) ModTime() time.Time {
	return fi.modTime
}
func (fi bindataFileInfo) IsDir() bool {
	return false
}
func (fi bindataFileInfo) Sys() interface{} {
	return nil
}

var _dataTutorialDockerHostIpDockerMachineTxt = []byte("\x1f\x8b\x08\x00\x00\x09\x6e\x88\x00\xff\x52\x56\x70\xf1\x77\xf6\x76\x0d\x8a\xf7\xf0\x0f\x0e\x89\xf7\x0c\xb0\x55\xd1\x48\xc9\x4f\xce\x4e\x2d\xd2\xcd\x4d\x4c\xce\xc8\xcc\x4b\x55\xc8\x2c\x50\xf0\x73\xf4\x75\xd5\xe4\x02\x04\x00\x00\xff\xff\x3b\x6b\x3a\x0e\x2b\x00\x00\x00")

func dataTutorialDockerHostIpDockerMachineTxtBytes() ([]byte, error) {
	return bindataRead(
		_dataTutorialDockerHostIpDockerMachineTxt,
		"data/tutorial/docker-host-ip-docker-machine.txt",
	)
}

func dataTutorialDockerHostIpDockerMachineTxt() (*asset, error) {
	bytes, err := dataTutorialDockerHostIpDockerMachineTxtBytes()
	if err != nil {
		return nil, err
	}

	info := bindataFileInfo{name: "data/tutorial/docker-host-ip-docker-machine.txt", size: 43, mode: os.FileMode(420), modTime: time.Unix(1477516107, 0)}
	a := &asset{bytes: bytes, info: info}
	return a, nil
}

var _dataTutorialDockerHostIpDockermacTxt = []byte("\x1f\x8b\x08\x00\x00\x09\x6e\x88\x00\xff\x52\x56\x70\xf1\x77\xf6\x76\x0d\x8a\xf7\xf0\x0f\x0e\x89\xf7\x0c\xb0\x55\xd1\xc8\x4c\x4b\xce\xcf\x4b\xcb\x4c\x57\xa8\x51\x48\x2f\x4a\x2d\x50\xc8\xcc\x4b\x2d\x81\xb1\x75\xcb\xc0\x5c\x33\x24\xbe\xa1\x91\xb9\x9e\x81\x9e\x81\x9e\xa1\x42\x8d\x42\x46\x6a\x62\x8a\x82\x6e\x1e\x88\x99\x58\x9e\xad\xa0\x5e\x5d\x50\x94\x99\x57\xa2\xa0\x62\x54\xab\xae\xc9\x05\x08\x00\x00\xff\xff\x46\x83\xec\x58\x6b\x00\x00\x00")

func dataTutorialDockerHostIpDockermacTxtBytes() ([]byte, error) {
	return bindataRead(
		_dataTutorialDockerHostIpDockermacTxt,
		"data/tutorial/docker-host-ip-dockermac.txt",
	)
}

func dataTutorialDockerHostIpDockermacTxt() (*asset, error) {
	bytes, err := dataTutorialDockerHostIpDockermacTxtBytes()
	if err != nil {
		return nil, err
	}

	info := bindataFileInfo{name: "data/tutorial/docker-host-ip-dockermac.txt", size: 107, mode: os.FileMode(420), modTime: time.Unix(1477516105, 0)}
	a := &asset{bytes: bytes, info: info}
	return a, nil
}

var _dataTutorialDockerRun5000Txt = []byte("\x1f\x8b\x08\x00\x00\x09\x6e\x88\x00\xff\x6c\x90\x4f\x6f\xda\x40\x10\xc5\xef\x7c\x8a\x91\x9b\xab\x1d\x03\x4b\xc1\x48\xb4\x52\x29\x4d\x51\xa2\x18\x81\xb9\x55\xb2\xf6\xcf\x60\xaf\xb2\xec\x92\xdd\x71\x29\x8d\xf2\xdd\x2b\x93\x86\xca\x69\xae\x33\xf3\xde\xbc\xf7\xfb\x00\xca\xc9\x07\xf4\xe0\x1b\x0b\xb1\x82\x1f\x3d\x80\x38\xb6\x7c\x8f\xa0\xb4\xad\x5c\x7c\x70\x81\x2a\x8f\xe1\xd1\xbc\xec\x10\xbe\xe6\xf3\xdb\xc5\xba\xfc\x9e\x6f\x8a\x72\xb9\x9a\x5d\x3d\x75\x07\xd3\xcf\x1e\x1f\x1b\xed\x51\x3d\xbf\xa7\x58\xe5\xeb\xa2\x1c\xb1\xe1\x60\x76\xf5\xb4\xda\x7e\xb9\x5b\xce\xcf\xa3\x67\x88\x0f\xd0\x9d\x4c\xdb\xab\x8b\xc5\xf2\xfe\x26\x2f\xf3\xf5\x4d\x59\xe4\xb7\x8b\xfb\x59\x65\x9c\xe0\x26\x76\xbe\xea\x5e\xcc\xef\xb6\x9b\x62\xb1\x9e\x29\xdc\xbb\x58\x9a\x26\x10\xfa\x78\x4d\xa4\xc7\xf9\xf9\xf0\x5c\x8a\xb4\xc1\x70\xfd\xb6\xdf\xd4\x70\xc2\x40\xbd\x8c\xa9\xfe\x64\x98\xca\x8f\x4c\xa4\x83\xe1\x18\x53\x99\xf5\xd5\x24\x4d\x33\x81\x23\x26\x06\x82\xc9\xac\x2f\x27\xfd\xdd\x90\x0f\x84\x60\xe3\x51\x96\x29\xa6\xfa\x8c\x8d\x11\x25\xe3\x6c\xd4\xbb\x30\x35\xae\x0a\xff\x61\xec\x25\x49\xd2\x3b\x70\xf2\xce\xea\x4f\x50\xd4\x08\xbb\x36\x0e\x08\x34\xce\x56\xda\x56\x40\x0e\xa8\xd6\x01\x14\x27\x2e\x78\x40\x08\xa7\x40\xb8\x87\xa3\x36\x06\x04\x82\x3b\x5a\x54\x20\x4e\xd0\x04\xf4\x10\xbd\x5a\x47\x1d\x5b\x1d\x5e\xd6\xfb\x26\x10\x70\x13\x5c\x2b\x03\xaa\x11\x02\xfa\x9f\xe8\xe1\xe0\x9d\xc4\x10\xfe\x89\xba\xa1\x2e\xcf\xff\x42\xbc\x7c\xd7\x56\x93\xe6\x46\xff\x46\x05\x47\x4d\x35\x18\x27\xb9\x41\x88\xd0\x96\xdb\x4d\xb2\x2d\xbe\xc5\x93\xe8\x4d\x43\x85\x3b\xde\x18\x02\xc2\x5f\x04\x01\xb9\x97\x35\x48\x67\x77\xba\x6a\x3c\x27\xed\xec\xc5\x3d\x20\xb5\xfd\x23\xb4\x95\xd1\xa1\x8e\xde\x8b\x27\x3d\x72\x6a\x41\x29\xed\x51\x92\xf3\x27\xb8\x6e\xe3\x5e\xbf\x92\x48\x21\x49\x12\x70\x0f\x67\xd4\x7f\x02\x00\x00\xff\xff\x29\x4c\x89\xe2\xe2\x02\x00\x00")

func dataTutorialDockerRun5000TxtBytes() ([]byte, error) {
	return bindataRead(
		_dataTutorialDockerRun5000Txt,
		"data/tutorial/docker-run-5000.txt",
	)
}

func dataTutorialDockerRun5000Txt() (*asset, error) {
	bytes, err := dataTutorialDockerRun5000TxtBytes()
	if err != nil {
		return nil, err
	}

	info := bindataFileInfo{name: "data/tutorial/docker-run-5000.txt", size: 738, mode: os.FileMode(420), modTime: time.Unix(1477517883, 0)}
	a := &asset{bytes: bytes, info: info}
	return a, nil
}

var _dataTutorialGetStartedTxt = []byte("\x1f\x8b\x08\x00\x00\x09\x6e\x88\x00\xff\x54\x8e\x41\xab\xc2\x30\x10\x84\xef\xf9\x15\x03\xef\xf0\x5a\x78\xcf\xe0\x7f\xe8\xd1\x83\xe2\xb5\x30\x96\x36\xd6\x60\x4d\x34\x69\x85\xc2\xfe\x78\xd9\x16\x11\x77\x61\x58\xe6\x1b\x96\xf9\x41\x17\xdb\xab\x4b\x48\x53\x40\xe7\x43\x1f\x47\x3f\xb8\x6c\x97\xf3\xff\x1e\xf3\xd8\x27\x97\x1f\x83\x01\x49\x02\x34\x02\x10\x75\xc1\x92\x50\x43\x45\x7d\x2a\x79\xef\x2f\x51\xc3\x82\x27\x88\xd5\xb4\x22\x7e\xb0\xa0\xe0\xaa\x25\xc4\x88\x7e\xb6\xc2\x25\x41\xa9\xc9\x3f\xa8\xd2\x1a\x7c\x8f\x2c\xa6\xa9\xb4\x1b\xf6\x6b\xb7\xe3\x61\x87\x36\x86\xd1\x87\x29\x4e\x79\x98\xd1\xa4\xf6\xe2\x9f\xae\xc3\x39\xc5\x1b\xaa\x66\xc6\x76\x63\x5e\x01\x00\x00\xff\xff\x0e\x5e\x12\x06\xe7\x00\x00\x00")

func dataTutorialGetStartedTxtBytes() ([]byte, error) {
	return bindataRead(
		_dataTutorialGetStartedTxt,
		"data/tutorial/get-started.txt",
	)
}

func dataTutorialGetStartedTxt() (*asset, error) {
	bytes, err := dataTutorialGetStartedTxtBytes()
	if err != nil {
		return nil, err
	}

	info := bindataFileInfo{name: "data/tutorial/get-started.txt", size: 231, mode: os.FileMode(420), modTime: time.Unix(1477516098, 0)}
	a := &asset{bytes: bytes, info: info}
	return a, nil
}

var _dataTutorialShowUsageTxt = []byte("\x1f\x8b\x08\x00\x00\x09\x6e\x88\x00\xff\x7c\x51\x61\x6b\xdb\x30\x14\xfc\xae\x5f\x71\xb0\xc0\x12\x98\xe6\xac\x5b\xbf\x04\xcc\x60\x49\x48\x43\x42\x9d\x39\xce\x37\xc3\x9b\x27\xab\xae\x98\x63\x25\xb2\xd4\xad\x54\xfd\xef\x43\x6e\xbb\x39\xd9\xa8\x04\x0f\x71\x77\xef\xe9\x74\x7a\x83\x52\x8b\x1f\xd2\xc0\xb8\x06\xa5\x6a\x2a\x6d\x55\x2d\xdb\xa8\x3b\xf2\x83\x6e\x6d\x65\x64\x7b\xac\x19\x88\x88\x00\x62\x1e\x20\xe4\x43\x1a\x11\x02\x10\x4a\xc0\x29\x30\x2f\xfb\x2d\x21\x47\x04\xfa\x06\x1f\x05\x75\xa0\xe8\x2f\xed\x31\xa4\xa7\x3a\x82\x67\x3e\x4c\x8e\x3c\x75\x0a\xf2\x39\xd1\x3b\x84\x4a\x11\xc3\xe9\xf2\x1d\xc8\x66\xc1\x1b\x36\x4f\xde\xb6\x5f\xd7\x10\xba\xb1\xaa\x71\xda\xb5\xf5\x3d\x0a\x23\x6e\xd5\x9d\x2c\x71\x63\xf4\x1e\xb3\xe2\x1e\x1f\xde\x33\x76\xa5\x7f\xc2\xea\xf0\xca\x09\x63\xc0\x66\xf7\x65\xbd\x9c\xd2\x26\x49\xb3\xf8\x72\x3c\x1e\x33\xf4\x73\xe0\x25\xf2\xee\x6e\xce\x9b\x62\x2f\x71\x1e\xc6\x0b\x2b\x31\x4b\xa6\xab\x79\x4a\x57\xc9\x36\xa3\xe5\x26\x1e\x3c\x9c\x02\x93\xcf\x46\x1e\x9d\x32\xb2\x7c\xfc\x7f\x4f\x30\x40\x97\x9f\x3e\x5e\xc4\x83\x87\x9e\xa7\x47\xf0\x03\x4e\x91\x49\x50\xf5\x86\x2c\xaf\x17\x09\x25\xe9\x82\xb2\x64\x35\xbf\x8e\xab\x5a\x7f\x2f\x6a\xae\x4d\x75\xae\x99\xae\x77\xdb\x6c\x9e\xc6\xa5\xdc\x6b\x2e\x6a\xd7\x5a\x69\xf8\x62\x75\x7b\x77\x71\x7c\x96\xbe\xf2\xed\x93\xba\xb0\xb2\xb5\x7f\xf2\xab\xa4\x45\xa9\x8c\x14\xb6\x9f\xff\x2e\x5d\x76\xa9\xc2\x19\x15\x0f\x86\xcf\x49\xca\x5f\x52\xfc\x1b\x9d\x28\x2c\x22\xa1\x9b\x1b\x55\x45\xce\xa8\x51\x68\x3b\x04\x62\xe0\x8c\x62\xbf\x03\x00\x00\xff\xff\x70\x7b\xae\xe4\x8f\x02\x00\x00")

func dataTutorialShowUsageTxtBytes() ([]byte, error) {
	return bindataRead(
		_dataTutorialShowUsageTxt,
		"data/tutorial/show-usage.txt",
	)
}

func dataTutorialShowUsageTxt() (*asset, error) {
	bytes, err := dataTutorialShowUsageTxtBytes()
	if err != nil {
		return nil, err
	}

	info := bindataFileInfo{name: "data/tutorial/show-usage.txt", size: 655, mode: os.FileMode(420), modTime: time.Unix(1477516100, 0)}
	a := &asset{bytes: bytes, info: info}
	return a, nil
}

// Asset loads and returns the asset for the given name.
// It returns an error if the asset could not be found or
// could not be loaded.
func Asset(name string) ([]byte, error) {
	cannonicalName := strings.Replace(name, "\\", "/", -1)
	if f, ok := _bindata[cannonicalName]; ok {
		a, err := f()
		if err != nil {
			return nil, fmt.Errorf("Asset %s can't read by error: %v", name, err)
		}
		return a.bytes, nil
	}
	return nil, fmt.Errorf("Asset %s not found", name)
}

// MustAsset is like Asset but panics when Asset would return an error.
// It simplifies safe initialization of global variables.
func MustAsset(name string) []byte {
	a, err := Asset(name)
	if err != nil {
		panic("asset: Asset(" + name + "): " + err.Error())
	}

	return a
}

// AssetInfo loads and returns the asset info for the given name.
// It returns an error if the asset could not be found or
// could not be loaded.
func AssetInfo(name string) (os.FileInfo, error) {
	cannonicalName := strings.Replace(name, "\\", "/", -1)
	if f, ok := _bindata[cannonicalName]; ok {
		a, err := f()
		if err != nil {
			return nil, fmt.Errorf("AssetInfo %s can't read by error: %v", name, err)
		}
		return a.info, nil
	}
	return nil, fmt.Errorf("AssetInfo %s not found", name)
}

// AssetNames returns the names of the assets.
func AssetNames() []string {
	names := make([]string, 0, len(_bindata))
	for name := range _bindata {
		names = append(names, name)
	}
	return names
}

// _bindata is a table, holding each asset generator, mapped to its name.
var _bindata = map[string]func() (*asset, error){
	"data/tutorial/docker-host-ip-docker-machine.txt": dataTutorialDockerHostIpDockerMachineTxt,
	"data/tutorial/docker-host-ip-dockermac.txt": dataTutorialDockerHostIpDockermacTxt,
	"data/tutorial/docker-run-5000.txt": dataTutorialDockerRun5000Txt,
	"data/tutorial/get-started.txt": dataTutorialGetStartedTxt,
	"data/tutorial/show-usage.txt": dataTutorialShowUsageTxt,
}

// AssetDir returns the file names below a certain
// directory embedded in the file by go-bindata.
// For example if you run go-bindata on data/... and data contains the
// following hierarchy:
//     data/
//       foo.txt
//       img/
//         a.png
//         b.png
// then AssetDir("data") would return []string{"foo.txt", "img"}
// AssetDir("data/img") would return []string{"a.png", "b.png"}
// AssetDir("foo.txt") and AssetDir("notexist") would return an error
// AssetDir("") will return []string{"data"}.
func AssetDir(name string) ([]string, error) {
	node := _bintree
	if len(name) != 0 {
		cannonicalName := strings.Replace(name, "\\", "/", -1)
		pathList := strings.Split(cannonicalName, "/")
		for _, p := range pathList {
			node = node.Children[p]
			if node == nil {
				return nil, fmt.Errorf("Asset %s not found", name)
			}
		}
	}
	if node.Func != nil {
		return nil, fmt.Errorf("Asset %s not found", name)
	}
	rv := make([]string, 0, len(node.Children))
	for childName := range node.Children {
		rv = append(rv, childName)
	}
	return rv, nil
}

type bintree struct {
	Func     func() (*asset, error)
	Children map[string]*bintree
}
var _bintree = &bintree{nil, map[string]*bintree{
	"data": &bintree{nil, map[string]*bintree{
		"tutorial": &bintree{nil, map[string]*bintree{
			"docker-host-ip-docker-machine.txt": &bintree{dataTutorialDockerHostIpDockerMachineTxt, map[string]*bintree{}},
			"docker-host-ip-dockermac.txt": &bintree{dataTutorialDockerHostIpDockermacTxt, map[string]*bintree{}},
			"docker-run-5000.txt": &bintree{dataTutorialDockerRun5000Txt, map[string]*bintree{}},
			"get-started.txt": &bintree{dataTutorialGetStartedTxt, map[string]*bintree{}},
			"show-usage.txt": &bintree{dataTutorialShowUsageTxt, map[string]*bintree{}},
		}},
	}},
}}

// RestoreAsset restores an asset under the given directory
func RestoreAsset(dir, name string) error {
	data, err := Asset(name)
	if err != nil {
		return err
	}
	info, err := AssetInfo(name)
	if err != nil {
		return err
	}
	err = os.MkdirAll(_filePath(dir, filepath.Dir(name)), os.FileMode(0755))
	if err != nil {
		return err
	}
	err = ioutil.WriteFile(_filePath(dir, name), data, info.Mode())
	if err != nil {
		return err
	}
	err = os.Chtimes(_filePath(dir, name), info.ModTime(), info.ModTime())
	if err != nil {
		return err
	}
	return nil
}

// RestoreAssets restores an asset under the given directory recursively
func RestoreAssets(dir, name string) error {
	children, err := AssetDir(name)
	// File
	if err != nil {
		return RestoreAsset(dir, name)
	}
	// Dir
	for _, child := range children {
		err = RestoreAssets(dir, filepath.Join(name, child))
		if err != nil {
			return err
		}
	}
	return nil
}

func _filePath(dir, name string) string {
	cannonicalName := strings.Replace(name, "\\", "/", -1)
	return filepath.Join(append([]string{dir}, strings.Split(cannonicalName, "/")...)...)
}

