1. 전체적으로 main/development/bastion 문서를 참고해서 만들면 좋아요. bastion은 EC2머신을 하나 올려서 쓰는거에요.
2. AMI는 ECS최신걸 쓰고, keypair는 pickstudio을 쓰면 됩니다.
3. instance에 profile role을 달아야하는데, Role을 직접 만들어서 정의하는걸 추천합니다.
    1. 이 부분은 development/ecs/pickstudio/services/sample 참고 할 수 있어용.
    
