[선행확인]
1. tfstate파일 저장용 S3 생성
2. dynamo DB 테이블 생성(파티션키는 아무렇게 적어도 됨. ex:LockID)

[테라그런트 배포]
1. ```sh getSource.sh```\
    안내문에 따라 backend_tfstate저장을 위한 S3이름, dynamo DB 테이블 이름 입력
    -> (Root)terragrunt.hcl에 자동 입력됨.

2. ```sh first.sh```\
    쉘 파일이 자동으로 keypair, .terraform체크 후 init, fmt 진행.

    <<DEV 전체 배포>>
    ```
    terragrunt run-all --terragrunt-ignore-external-dependencies --terragrunt-working-dir "./DEV/" apply
    ```

    <<DEV infra"만" 배포>>
    ```
    terragrunt run-all --terragrunt-ignore-external-dependencies --terragrunt-working-dir "./DEV/DEV_infra/" apply
    ```

    <<DEV EKS"만" 배포>>
    ```
    terragrunt run-all --terragrunt-ignore-external-dependencies --terragrunt-working-dir "./DEV/DEV_EKS/" apply
    ```

    <<PROD 전체 배포>>
    ```
    terragrunt run-all --terragrunt-ignore-external-dependencies --terragrunt-working-dir "./PROD/" apply
    ```
    
    <<DEV, PROD 전체 배포>>
    ```
    terragrunt run-all --terragrunt-ignore-external-dependencies --terragrunt-working-dir "./" apply
    ```
    
    
    
