fileName=signalbench-1.6.19-linux-musl-x86_64
release=v1.6.19

wget https://github.com/gocortexio/signalbench/releases/download/$release/$fileName
sudo chmod +x $fileName
sudo mv $fileName /usr/local/bin/signalbench

categories=$(signalbench list | grep "CATEGORY" | cut -d ' ' -f 2- | xargs)

signalbench category $categories