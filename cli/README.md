# Getting started

#### install

``` bash
cd ${PROJECT_PATH}
./cli/install.sh

pstd -h

---------------- Output
Description: script files
Usage: pstd
  -s bash script file name
  -o parameter strings
  [-h help]

  Required: Required AWS Credential keys

  case0[update pstd]:
    pstd -s update

  case1[bastion membere 등록]:
    pstd -s add-sg-myip -o "drake-jin"

  case2[bastion의 haporxy 내용변경]:
    pstd -s refresh-haproxy -o drake-jin

  case3[뭔가 dev채널에 slack message 남기기]:
    pstd -s slack.shout -o "어쩌고 저쩌고~"
```

#### delete

``` bash
./cli/delete.sh

pstd -h
# won't work
```

#### release

``` bash
./cli/release.sh

pstd -s update
```
