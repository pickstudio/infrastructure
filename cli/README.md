# Getting started

pickstudio의 개발환경 구축 CLI, VPN 접속, bastion ssh tunneling을 위해서 해당 프로그램을 사용해야합니다.
더 나아가서는 pickstudio의 Secret(Credential)한 정보를 획득하는데에 사용할 수 도 있습니다.

# Requirements
- OS: Ubuntu, Fedora, MacOS(LINUX/UNIX based OS)한정
- CLI: aws-cli v2 [Donwload Link](https://docs.aws.amazon.com/ko_kr/cli/latest/userguide/install-cliv2.html)
- CLI: jq [Download Link](https://stedolan.github.io/jq/download/)
- Window이용자는 이용할 수 없습니다. Window이용자는 직접 수동작업 하시면 됩니다.


# Usage

- `update`: pstd cli를 업데이트 할 수 있습니다.
- `add-sg-myip "nickname"`: 현재 사용하고 있는 머신의 Public IPf를 Security Group에 등록합니다.
- `refresh-haproxy`[준비중]: 업데이트한 haproxy의 설정을 반영합니다.
- `slack-call`[준비중]: slack으로 테스트 메세지를 보냅니다.


# Features

#### ptsd -s `add-sg-myip` -o drake-jin

해당 기능은 현재 작업자의 IP가 bastion 에 접근한 후에, ssh 터널링하여 private network에 있는 노드들에게 접속하기 위해 사용하기 위한 기능입니다.
**단순히 사용자 접속용 security group에 자신의 IP로 방화벽을 여는기능입니다.** 그 이상도 아니고, 그 이하도 아닙니다.
해당 기능은 중복해서 여러번 사용한다고 여러 레코드가 계속 생성되어 남지 않습니다. **대신 nickname은 항상 같은것을 이용해주셔야만 합니다.**

``` bash
ptsd -s add-sg-myip -o drake-jin
ssh ec2-user@bastion.pickstudio.io
```

# install & uninstall

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
