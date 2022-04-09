# remote_ec2

# Getting started
VScode ssh모드로 실행시키기 위한 준비

1. pem키 다운로드 받기

``` bash
./scripts/downloadSecrets.sh
```

2. AWS 에서 security 방화벽 [open](https://ap-northeast-2.console.aws.amazon.com/ec2/v2/home?region=ap-northeast-2#SecurityGroup:groupId=sg-09428512ecb5d19c6)
    1. AWS Console에 접근한다.
    2. security group에서 `member` 라는 security group name을 찾는다.
    3. SSH 로 22번을 열고 `My IP` 항목을 선택해야한다.
      - IP는 절대 `0.0.0.0/0` 을 하면 절대 안됩니다.

3. VScode에서 playground server등록하기(자신의 로컬 머신에서)
    1. 명령 pallette열기 `cmd + p`
    2. 검색 `> Remote ssh` 치면 Add host가 나옴
    3. host 등록시에 아래와 같은 포맷으로 입력할것.
``` bash
# VSCode remote ssh host 등록시에
# ssh -i {pem키 절대경로} ec2-user@playground.development.pickstudio.io
# example
ssh -i /Users/drakejin/Workspace/pickstudio/infrastructure/pickstudio.pem ec2-user@playground.development.pickstudio.io
```
### [이미지 자료 참고]
- ![1images](../docs/_images/vscode_ssh_1.png)
- ![2images](../docs/_images/vscode_ssh_2.png)
- ![3images](../docs/_images/vscode_ssh_3.png)
- ![4images](../docs/_images/vscode_ssh_4.png)


# WIKI
### 처음 initialize한 ec2셋업 - github이용하게 하기

``` bash
cat ~/.ssh/id_rsa.pub
# 이 내용을 github / profile /seetings / SSH & GPG Key 관리에서 등록해주기  pickstudio.pem 이라 하면 됨.
```

### 처음 initialize한 ec2셋업 - docker-compose install
``` bash
# 최신 docker compose를 해당 링크에서 받을 수 있다고 한다.
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose

# 권한 부여
sudo chmod +x /usr/local/bin/docker-compose
```
