# Amarok 설치

```bash
sudo add-apt-repository ppa:kubuntu-ppa/backports
sudo apt-get update --fix-missing
sudo apt-get install amarok
```

## moodbar 설치

```bash
sudo apt-get install moodbar
```

## moodbar 만드는 스크립트 (moodbar.sh로 만듬. 음악이 있는 폴더에서 수행)

```bash
#!/bin/bash

if [ $# -lt 2 ] ;then
  echo "Usage: ./moobar.sh <dirname>"
  exit 1
fi
#DIR=${1:-.}
DIR=$1
LAST=~/.moodbar-lastreadsong
C_RET=0
control_c()        # run if user hits control-c
{
  echo "" > "$LAST"
  echo "Exiting..."
  exit
}

if [ -e "$LAST" ]; then
  read filetodelete < "$LAST"
  rm "$filetodelete" "$LAST"
fi

exec 9< <(find "$DIR" -type f -regextype posix-awk -iregex '.*\.(mp3|ogg|flac|wma)') # you may need to add m4a and mp4
while read i
do
  TEMP="${i%.*}.mood"
  OUTF=`echo "$TEMP" | sed 's#\(.*\)/\([^,]*\)#\1/.\2#'`
  trap 'control_c "$OUTF"' INT
  if [ ! -e "$OUTF" ] || [ "$i" -nt "$OUTF" ]; then
    moodbar -o "$OUTF" "$i" || { C_RET=1; echo "An error occurred!" >&2; }
  fi
done <&9
exec 9<&-
exit $C_RET
```

## 전역 단축키 설정 하기 : configure shotcut 메뉴에서 수행

## easytag를 이용해서 ID3 tag UTF-8로 만들기

```bash
sudo apt-get install easytag
```

> edit -> preference -> ID3 Tag setting -> ID3v1 tag charset : UTF-8 -> Non-stand : Korean(EUC-KR) 후에 파일 리로드 후 저장하기

## MP3 normalizer

```bash
sudo apt-get install easymp3gain-gtk
```
