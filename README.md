# MSA 쇼핑몰 사이트 구현 프로젝트
## 1. Introduction
이 프로젝트는 Infrastructure as Code (IaC)를 활용하여 EKS 클래스터를 구축하고, MSA(Microservices Architecture) 기반의 쇼핑몰 애플리케이션을 구현하는 것에 중점을 두고 있습니다.


### 주요기능
- **Infrastructure as Code (IaC)**  
- **Kubernetes**  
- **CI/CD 파이프라인**  
- **인프러 모니터링**  
- **애플케이션 모니터**  

---

## 2. Architecture Design
[![architecture](https://github.com/user-attachments/assets/34796c22-80f6-4b0c-ac96-ae21defe5339)]()

위와 같은 구조로 전체 시스템이 구성되어 있습니다

<img width="1000" alt="dev_iac" src="https://github.com/user-attachments/assets/5a6c364f-c953-4694-ac7a-258c31ceed9c" />
개발자는 배스천 서버에서 Terragrunt 코드를 실행합니다.
<img width="1000" alt="dev_iac" src="https://github.com/user-attachments/assets/dac8e746-9b9f-4fee-9454-bffe78a6aeec" />

코드를 Git에 Push하면 GitHub Actions가 트리거되어 다음을 수행합니다:
- Docker 이미지를 빌드
- ECR에 푸시
- 배포 리포지토리의 이미지 태그 값을 업데이트
ArgoCD가 리포지토리의 변경을 감지하고 EKS 클러스터에 새로운 이미지를 배포합니다.
<img width="1000" alt="dev_iac" src="https://github.com/user-attachments/assets/b23f69f3-c1ab-4eeb-9bc9-eb631254ec4c" />
사용자가 Route53에 등록된 도메인으로 접근하면 요청은 인터넷 게이트웨이(IGW), **ALB(Application Load Balancer)**를 거쳐 Pod로 전달됩니다.

---

## 3. Tech Stack

| Category                 | Technology            | Logo                                                                                  | Description                                                      |
|--------------------------|-----------------------|---------------------------------------------------------------------------------------|------------------------------------------------------------------|
| **Container Orchestration** | **Amazon EKS**        | <img src="https://img.shields.io/badge/Amazon%20EKS-FF9900?style=flat-square&logo=amazonaws&logoColor=white"/> | 관리형 Kubernetes 서비스|
| **CI/CD**                | **GitHub Actions**    | <img src="https://img.shields.io/badge/GitHub%20Actions-2088FF?style=flat-square&logo=githubactions&logoColor=white"/> | GitHub 저장소에서 직접 CI/CD 워크플로우 자동화     |
| **Infrastructure as Code** | **Terragrunt**       | <img src="https://img.shields.io/badge/Terragrunt-5C2D91?style=flat-square&logo=terraform&logoColor=white"/> |Terraform의 래퍼로 효율적인 IaC 관리            |
| **Infrastructure as Code** | **Kustomize**        | <img src="https://img.shields.io/badge/Kustomize-326CE5?style=flat-square&logo=kubernetes&logoColor=white"/> | Kubernetes-native 설정 관리 도구     |
| **Monitoring**           | **Prometheus**        | <img src="https://img.shields.io/badge/Prometheus-E6522C?style=flat-square&logo=prometheus&logoColor=white"/> | 오픈소스 시스템 모니터링 및 경고 도구         |
| **Monitoring**           | **Grafana**           | <img src="https://img.shields.io/badge/Grafana-F46800?style=flat-square&logo=grafana&logoColor=white"/> | 시각화 및 대시보드 플랫폼                  |
| **Monitoring**           | **Datadog**           | <img src="https://img.shields.io/badge/Datadog-632CA6?style=flat-square&logo=datadog&logoColor=white"/> | 	클라우드 기반 애플리케이션 모니터링 플랫폼                 |
| **GitOps**               | **ArgoCD**            | <img src="https://img.shields.io/badge/ArgoCD-2496ED?style=flat-square&logo=argo&logoColor=white"/> | GitOps 기반 Kubernetes 배포 툴             |
| **Container Registry**   | **Amazon ECR**        | <img src="https://img.shields.io/badge/Amazon%20ECR-FF9900?style=flat-square&logo=amazonecr&logoColor=white"/> | Docker 이미지 저장용 보안 레지스트리         |
| **Database**             | **Amazon RDS**        | <img src="https://img.shields.io/badge/Amazon%20RDS-527FFF?style=flat-square&logo=amazonrds&logoColor=white"/> | 	확장 가능한 관리형 관계형 DB 서비스  |

---


## 4. Project Structure
### 리포지토리 구성

- 2MIR-FP-main: Terragrunt 코드 포함
- ecommerce-workshop-k8s-manifest-main: 쇼핑몰 애플리케이션 소스코드
- ecommerce-workshop-k8s-manifest-main: Kustomize 매니페스트 정보 포함

---

## 5. Implementation Details
### 5.1 Infrastructure as Code (IaC)
IaC는 인프라를 코드로 관리하여, 수동 작업 없이 신속하고 정확하게 인프라를 구축할 수 있게 해줍니다. 일반적으로 Terraform이 많이 사용되며, 환경별(dev, stage, prod) 반복 설정을 줄이기 위해 Terragrunt를 사용했습니다.

Terragrunt의 장점

인프라 자동화(IaC)를 위한 가장 일반적인 도구 중 하나는 **테라폼(Terraform)**이며, 이를 통해 인프라 자원을 생성하고 관리할 수 있습니다. 하지만 개발, 스테이징, 프로덕션 등 여러 환경에 동일한 인프라를 구축할 때 테라폼은 반복적인 설정을 요구하여 시간 소모적이고 오류 발생 가능성이 높습니다.

반복적인 작업을 최소화하고 확장성을 향상시키기 위해 **테라그런트(Terragrunt)**를 활용했습니다.

테라그런트(Terragrunt)란 무엇인가?
**테라그런트(Terragrunt)**는 테라폼을 래핑하여 인프라 코드를 효율적으로 관리할 수 있도록 추가 기능을 제공하는 얇은 래퍼(thin wrapper)입니다. 주요 이점은 다음과 같습니다.

- DRY (Don't Repeat Yourself) 원칙: 테라그런트는 여러 환경에서 공유된 설정을 허용하여 코드 중복을 줄입니다.
- 환경 격리: 재사용 가능한 컴포넌트를 유지하면서 서로 다른 환경을 위한 인프라를 격리하는 데 도움이 됩니다.
- 자동화된 워크플로우: 종속성 관리 및 모듈 구성과 같은 테라폼 작업을 단순화하고 자동화합니다.
테라그런트를 활용함으로써 반복적인 작업을 최소화하고 운영 효율성을 향상시키는 확장 가능하고 유지 관리 가능한 인프라 설정을 달성했습니다.

<img alt="terragrunt" width="1000" src="https://github.com/user-attachments/assets/aeefe4a3-424e-4e2c-83d9-73338ebbe084" />

##### 폴더 구조:
- **Origin Folder**: 공통 Terraform 코드(`.tf`).
- **DEV, PROD**: 환경별 `terragrunt.hcl` 파일로 관리.

##### 구성요소:
- **상위 `terragrunt.hcl`**: 공통 설정 정의
- **하 `terragrunt.hcl`**: 환경별 오버라이딩.
- **`env.hcl`**: 환경 변수 정의.

##### 이점:
- **코드 재사용성**: 반복적인 작업을 최소화합니다..
- **환경 확장성**: 새로운 환경 추가를 위한 설정 재사용을 가능하게 합니다..
- **AWS 리소스 관리**:  EKS, RDS, Route53, 서브넷과 같은 리소스를 효율적으로 배포합니다.

결론적으로, 테라그런트는 복잡한 인프라의 관리 및 확장성을 단순화합니다.

---

### 5.2 Kubernetes (EKS)
#### EKS vs K8s 자체 구축 비교
<img alt="comparison_eks_k8s" width="1000" src="https://github.com/user-attachments/assets/91390a8f-c02c-4cec-bb40-b85cd9181a9b" />

##### K8s (Kubernetes)
- **관리**: 수동 관리 필요
- **복잡도**: 높은 구성 복잡성
- **고가용성**: 직접 구성 필요

##### EKS (Amazon Elastic Kubernetes Service)
- **관리**: AWS 에서 직접 관리
- **복잡도**: AWS 콘솔/CLI로 간편 운영
- **고가용성**: 기본 제공

#### AWS LoadBalancer Controller
<img alt="comparison_eks_k8s" width="1000" src="https://github.com/user-attachments/assets/5128a0d0-a9d4-4636-a840-67f5b90aa054" />

1. Ingress 리소스 처리
- Kubernetes 클러스터에 **Ingress 리소스**가 생성되었는지 감지합니다.
- Ingress 규칙에 따라 트래픽 라우팅 구성을 생성합니다.

2. ALB 생성 및 관리
- Ingress 리소스 정의를 기반으로 **Application Load Balancer(ALB)**를 자동으로 생성합니다.
- 생성된 ALB를 통해 사용자 트래픽을 적절한 Kubernetes 서비스 및 Pod로 라우팅합니다.

3. 트래픽 라우팅
- ALB는 Ingress 규칙에 따라 트래픽을 올바른 서비스로 전달합니다.
- Kubernetes 서비스는 해당 트래픽을 적절한 Pod로 전달합니다.

4. 자동화
- ALB 생성, Ingress 규칙 적용, 보안 그룹 설정 등의 작업을 자동화합니다.
- 수동 작업의 필요성을 줄여 운영을 간소화합니다.

##### 예시 워크플로우
1. 사용자가 Kubernetes 클러스터에 **Ingress 리소스**를 생성합니다.
2. AWS LoadBalancer Controller가 해당 Ingress를 감지하고, 필요한 설정을 포함한 **ALB**를 생성합니다.
3. ALB는 Ingress 규칙에 따라 들어오는 요청을 적절한 Kubernetes 서비스로 라우팅합니다.
4. 해당 서비스는 트래픽을 올바른 Pod로 전달합니다.

이 워크플로우는 Kubernetes와 AWS Application Load Balancer(ALB)를 원활하게 통합할 수 있도록 하며,  
트래픽 관리를 위한 **관리형**, **확장 가능한 솔루션**을 제공합니다.


### 5.3 네임스페이스 분리
<img alt="Namespace Separation" width="1000" src="https://github.com/user-attachments/assets/9846ae8f-f97e-4646-a15f-6020962c28b7" />

##### 정의된 네임스페이스
- **argocd**: ArgoCD와 같은 배포 및 GitOps 도구를 위한 네임스페이스
- **ecommerce**: 전자상거래 애플리케이션과 관련된 네임스페이스
- **monitoring**: 모니터링 도구 및 서비스를 위한 네임스페이스

##### 네임스페이스 분리 이유
1. 운영적 이점  
   - 클러스터 내 리소스 관리를 단순화할 수 있음

2. 리소스 격리  
   - 각 네임스페이스는 고유한 리소스를 갖고 있어 애플리케이션 간 충돌이나 리소스 남용을 방지함

3. 접근 제어  
   - 네임스페이스 단위로 접근 권한을 설정할 수 있어, 인가된 사용자나 팀만 접근 가능하게 제한할 수 있음

---

### 5.4 CI/CD
#### Jenkins vs GitHub Actions
<img alt="JENKINS_GITHUBACTION" width="1000" src="https://github.com/user-attachments/assets/f3e24d9a-1c12-4b14-8034-c4d0c5f968c5" />

##### **Jenkins**
- **서버**: 별도의 서버 설치 및 유지 관리가 필요하며, 이는 높은 인프라 비용과 운영 부담으로 이어질 수 있음
- **초기 설정**: 설정이 복잡함. 파이프라인 및 플러그인 구성이 초보자에게 어려울 수 있음
- **자료**: 오랜 기간 축적된 공식/비공식 문서 및 커뮤니티 자료가 풍부하여 문제 해결에 유리함

##### **GitHub Actions**
- **서버**: 클라우드에서 동작하므로 별도의 서버 관리가 필요 없음. 인프라 비용 절감 및 운영 간소화 가능
- **초기 설정**: 간단한 UI와 사전 정의된 워크플로우 제공으로 사용하기 쉬움
- **자료**: Jenkins보다는 자료가 적지만, 점점 사용자와 자료가 증가하고 있음
- **GitHub Actions를 선택한 이유**:
  - **멀티 리포지토리 워크플로우에 유리함**: 빌드 이후 다른 저장소의 ECR 이미지 태그를 쉽게 업데이트 가능
  - **GitHub와의 강력한 통합성**: GitHub 내에서 바로 작업 가능하여 다양한 프로젝트 간 작업을 간소화
  - **클라우드 네이티브 유연성**: 서버를 직접 관리할 필요가 없어 파이프라인 로직 구현에 집중 가능

##### 핵심 요약: GitHub Actions를 선택한 이유?
GitHub Actions는 다음과 같은 작업에서 워크플로우를 단순화해주기 때문에 선택되었습니다:
- 빌드 이후 ECR 이미지 태그를 다른 저장소에 반영해야 하는 작업
- 이미 GitHub를 사용 중인 팀에서는 기본 통합 덕분에 별도 설정 없이 즉시 활용 가능

Jenkins는 유연성과 성숙한 기능을 제공하지만, **GitHub Actions는 사용 편의성과 특정 요구사항(예: 리포지토리 간 태그 업데이트 처리)에 대한 효율성에서 두드러졌습니다.**



---

#### **ArgoCD**

<img alt="JENKINS_GITHUBACTION" width="1000" src="https://velog.velcdn.com/images/baeyuna97/post/4c54fd96-dac9-4475-8097-cfcb00fc742b/image.png" />

- **쿠버네티스 전용 CD 도구**: 쿠버네티스 환경에서 지속적 배포(Continuous Deployment)를 관리하기 위해 특별히 설계된 도구입니다.
- **직관적인 웹 UI**: 배포 상태를 시각적으로 쉽게 관리할 수 있는 사용자 친화적인 인터페이스를 제공합니다.
- **히스토리 기반 롤백**: 이전 배포 이력을 바탕으로 손쉽게 이전 상태로 롤백할 수 있어 신뢰성과 복구 용이성을 확보할 수 있습니다.

---

#### **블루-그린 배포 (Blue-Green Deployment)**
<img alt="blue_green" width="1000" src="https://github.com/user-attachments/assets/3cc755cd-7fd0-4d90-8167-11e02dfee33c" />

- **무중단 배포**: 배포 중에도 서비스 중단 없이 운영할 수 있습니다.
- **기존 환경 재활용 가능**: 이전 환경(Blue)을 롤백이나 테스트 용도로 재사용할 수 있습니다.
- **버전 간 호환성 문제 없음**: 새로운 버전(Green)과 기존 버전(Blue)이 완전히 분리되어 있어 충돌이 발생하지 않습니다.

##### 다른 배포 전략 대비 장점:
1. **안정성**: 문제가 발생하면 기존 환경(Blue)으로 빠르게 롤백할 수 있어 안정적인 운영이 가능합니다.
2. **운영 환경과 유사한 테스트**: 트래픽을 전환하기 전에 새로운 버전(Green)을 실제와 유사한 환경에서 충분히 테스트할 수 있습니다.
3. **무중단 전환**: 롤링 또는 카나리 배포와 달리 전체 트래픽을 한 번에 전환함으로써 사용자에게 끊김 없는 경험을 제공합니다.
4. **간단한 트래픽 제어**: 로드 밸런서를 활용한 전환 방식으로 트래픽 제어가 간단하고 명확합니다.
5. **손쉬운 롤백**: 문제 발생 시 트래픽을 다시 Blue 환경으로 쉽게 전환할 수 있어 복구가 용이합니다.

> 블루-그린 배포는 서비스 중단 없이 안정적인 배포가 중요한 시스템에 특히 유리합니다.

---

#### Kustomize를 활용한 소스코드와 배포 리포지토리 분리

<img alt="separation of two repo" width="1000" src="https://github.com/user-attachments/assets/cd6e5660-51be-4578-9c1b-a2b93c6da6b7" />

##### 리포지토리 구조
- **소스코드 리포지토리**: 애플리케이션 소스코드만 포함합니다.
- **배포 리포지토리**: Kustomize 매니페스트 파일만 포함되어 있어 배포 관련 설정을 따로 관리합니다.

##### 배포 워크플로우

<p align="center">
  <img alt="separation of two repo" width="500" src="https://github.com/user-attachments/assets/c8d1f7e3-03ef-4a76-a198-b4991dbeef47" />
  <img alt="separation of two repo" width="500" src="https://github.com/user-attachments/assets/0c4959c6-253f-4e49-baa7-f7d8bf7a4468" />
</p>

1. **소스코드 변경**
   - 소스코드 리포지토리에 변경이 감지되면 GitHub Action이 실행됩니다.

2. **도커 이미지 빌드 및 푸시**
   - GitHub Action이 소스코드를 기반으로 새로운 도커 이미지를 빌드하고 ECR에 푸시합니다.

3. **이미지 태그 업데이트**
   - GitHub Action이 배포 리포지토리에 있는 Kustomize 매니페스트의 이미지 태그를 최신 태그로 업데이트합니다.

4. **ArgoCD 배포**
   - ArgoCD는 배포 리포지토리의 변경을 감지하고, EKS 클러스터에 자동으로 배포를 수행합니다.

5. **Slack 알림**
<img alt="slack_msg" width="800" src="https://github.com/user-attachments/assets/d032c797-3651-40ee-a164-d48e9336ac9e"/>

- 배포가 완료되면 ArgoCD가 Slack 채널에 성공 또는 실패 등의 결과를 공유하여 팀 전체가 확인할 수 있도록 합니다.


---


### 5.5 모니터링 (Monitoring)
<img alt="monitoring" width="1000" src="https://github.com/user-attachments/assets/6c630e11-0dc4-40ba-98ee-208986d3873e" />

- **인프라 모니터링**: Prometheus와 Grafana를 기반으로 Blackbox Exporter, Node Exporter, Alertmanager를 활용해 시스템 수준의 메트릭과 알림을 수집 및 관리합니다.
- **애플리케이션 모니터링**: Datadog의 RUM(실사용자 모니터링)을 통해 애플리케이션 성능과 사용자 행동을 실시간으로 분석합니다.
- **알림**: Slack과 Gmail을 통해 실시간 알림 및 로그를 전달하여 빠른 대응이 가능합니다.

---

#### Prometheus 구성 요소
<img alt="monitoring" width="1000" src="https://github.com/user-attachments/assets/e8b8159b-d518-4f9f-a0c9-e10ba13d73ba" />

##### **Pull 방식 수집**
- Prometheus는 일반적인 Push 방식과 달리 **Pull 방식**으로 메트릭을 수집합니다.
- Prometheus 서버가 주기적으로 대상(클라이언트)에게 직접 데이터를 요청합니다.

##### **Pull 방식 동작 원리**
- Prometheus 서버가 Exporter가 설치된 대상에 직접 접속하여 메트릭을 수집합니다.
- 중앙에서 일괄적으로 수집 타이밍과 대상을 제어할 수 있어 관리가 편리합니다.

<p align="center">
  <img alt="blackbox_exporter" width="500" src="https://github.com/user-attachments/assets/b5f157ec-8d9b-448c-b2b9-d920def6a052" />
  <img alt="Node Exporter" width="500" src="https://github.com/user-attachments/assets/58943b08-1582-4e3e-9aa0-6fda76becdc7" />
</p>

1. **Blackbox Exporter**
- **역할**: 외부 엔드포인트의 상태를 능동적으로 검사합니다.
- **기능**:
  - HTTP, HTTPS, TCP, DNS, ICMP(ping) 모니터링
  - 응답 상태, 지연 시간, 패킷 손실 등을 측정
- **활용 예시**: 외부 API, 웹사이트 등 외부 서비스의 접근성과 응답 상태를 모니터링합니다.

2. **Node Exporter**
- **역할**: 개별 노드의 하드웨어 및 OS 레벨 메트릭을 수집합니다.
- **수집 항목**:
  - CPU 사용량
  - 메모리 사용량
  - 디스크 I/O
  - 파일시스템 사용량
  - 네트워크 상태
- **활용 예시**: 노드 상태와 리소스 사용량을 모니터링하여 장애 원인 분석에 활용됩니다.

3. **Alertmanager**
- **역할**: Prometheus가 생성한 알림을 관리 및 라우팅합니다.
- **기능**:
  - 알림 중복 제거, 그룹화 및 필터링
  - Slack, 이메일, PagerDuty 등 다양한 채널로 전송
  - 알림 무시 설정(사일런싱), 라우팅 조건 설정 가능
- **활용 예시**: 특정 임계치 초과 시 실시간 알림을 통해 운영 팀에 통보

> 위 세 가지 컴포넌트는 함께 동작하여 다음과 같은 통합된 모니터링 솔루션을 구성합니다:
- **Blackbox Exporter**: 외부 서비스 상태 점검
- **Node Exporter**: 내부 인프라 리소스 감시
- **Alertmanager**: 효율적인 알림 전달 및 통합 관리

---

#### 쿠버네티스 내 Datadog 에이전트 구성
<img alt="datadog" width="1000" src="https://private-user-images.githubusercontent.com/63151655/402612278-6c054361-4d61-4cd5-84db-d3276527165f.jpg?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDY5ODA2MjUsIm5iZiI6MTc0Njk4MDMyNSwicGF0aCI6Ii82MzE1MTY1NS80MDI2MTIyNzgtNmMwNTQzNjEtNGQ2MS00Y2Q1LTg0ZGItZDMyNzY1MjcxNjVmLmpwZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNTA1MTElMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjUwNTExVDE2MTg0NVomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPWQ3MzcyMDAzYjBkYjMxY2Q1MjdiZGVlMzUwMzY4MmRhMDIzNmMzOTJjNzc2YjhkYTExOTIyZDA3ZWY5MzBiZTYmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0In0.JBQupq-6ub6ZiwmK1MlQAvmaDzlrHelZ14aC6gsWQfA" />

##### Datadog Cluster Agent
- **역할**: Deployment 형태로 동작하며 Kubernetes API 서버와 통신해 클러스터 수준의 메트릭을 수집합니다.
- **기능**: Node Agent를 효율적으로 관리하고, 클러스터 레벨의 정보를 제공합니다.

##### Datadog Node Agent
- **역할**: DaemonSet 형태로 모든 노드에 배포되어 각 노드와 컨테이너의 메트릭, 로그, 트레이스를 수집합니다.
- **데이터 수집 경로**:
  - Kubelet: 노드 레벨 메트릭
  - 어플리케이션 컨테이너: 앱 내부 로그 및 지표

---

#### Datadog 애플리케이션 모니터링

**Datadog Live Search**
<img alt="datadog_livesearch" width="1000" src="https://github.com/user-attachments/assets/bb1fe3ef-afef-4887-a5bd-985d8b331015" />

- **Datadog Live Search**는 로그, 메트릭, 이벤트, 트레이스를 통합 검색할 수 있는 기능으로 문제 발생 시 전체 시스템 상태를 한눈에 파악할 수 있습니다.

**예시 시나리오**
- **advertisement 서비스**가 의도적으로 중단되었고, **GET /ads** 요청이 **500 Internal Server Error**로 응답되었으며, 이 오류는 Live Search를 통해 탐지 및 분석되었습니다.

---

**RUM (Real User Monitoring)**
<img alt="rum" width="1000" src="https://github.com/user-attachments/assets/03796b54-f211-48c1-9707-f0d48cecc974" />

실사용자 모니터링(RUM)은 실제 사용자의 앱 사용 행태를 바탕으로 성능과 UX를 정밀하게 분석합니다.

**Core Web Vitals**
- **LCP (Largest Contentful Paint)**: 가장 큰 콘텐츠가 렌더링되기까지의 시간 → 페이지 로딩 성능
- **FID (First Input Delay)**: 사용자 첫 입력이 반응하기까지의 지연 시간 → 반응성 측정
- **CLS (Cumulative Layout Shift)**: 예기치 않은 레이아웃 이동 → 시각적 안정성

**사용자 분석**
- **전체 세션 수**: 애플리케이션을 사용한 사용자 세션의 총 수
- **가장 많이 방문한 페이지**: 사용자가 가장 자주 찾는 페이지

---

**Session Explorer**
<img alt="Session Explorer" width="1000" src="https://github.com/user-attachments/assets/9979353d-5bcc-4d2b-9937-7e3991f17ea0" />

**세션 탐색기(Session Explorer)**는 사용자 경험 분석에 효과적인 도구로 다음 기능을 포함합니다:

- **사용자 이벤트 이력**: 사용자가 페이지를 어떻게 탐색하고 클릭했는지 등 상세 활동 추적
- **세션 재생**: 실제 사용자가 웹페이지를 어떻게 사용했는지 영상을 재생하듯 확인 가능 → UX 문제 파악 및 디버깅에 매우 유용


## 6. Setup & Deployment
### 6.1 Prometheus & Grafana 설치

Metrics Server 설치
```bash
VER=$(curl -s https://api.github.com/repos/kubernetes-sigs/metrics-server/releases/latest | grep tag_name | cut -d '"' -f 4 | sed 's/v//')
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v$VER/components.yaml
```

kubectl top 명령 사용 활성화
```bash
kubectl get apiservice v1beta1.metrics.k8s.io -o yaml
```

모든 노드에 대한 메트릭 접근 확인
```bash
kubectl get --raw "/apis/metrics.k8s.io/v1beta1/nodes" | jq
```

Metrics Server 정상 작동 여부 확인

```bash
kubectl top nodes
```

EFS 퍼시스턴트 볼륨 배포

```bash
cd ~/kube-prometheus-stack/
kubectl apply -f efspv.yaml
```

Prometheus Helm 패키지 배포

```bash
kubectl create ns monitoring
helm install prometheus . -n monitoring -f values.yaml
```

AWS Load Balancer Controller 설정
```bash
# Install OIDC Provider
AWS_REGION='ap-northeast-2'
eksctl utils associate-iam-oidc-provider \
--region ${AWS_REGION} \
--cluster MIR-DEV-eks \
--approve

# Create IAM Service Account
ACCOUNT_ID=$ACCOUNT_ID
eksctl create iamserviceaccount \
--cluster MIR-DEV-eks \
--namespace kube-system \
--name aws-load-balancer-controller \
--attach-policy-arn arn:aws:iam::$ACCOUNT_ID:policy/AWSLoadBalancerControllerIAMPolicy \
--override-existing-serviceaccounts \
--approve

# Install Cert-Manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.0/cert-manager.yaml

# Deploy Load Balancer Controller
curl -Lo v2_5_4_full.yaml https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.5.4/v2_5_4_full.yaml
sed -i.bak -e '596,604d' ./v2_5_4_full.yaml
sed -i.bak -e 's|MIR-DEV-eks|eks-demo|' ./v2_5_4_full.yaml
kubectl apply -f v2_5_4_full.yaml

# Install IngressClass
curl -Lo v2_5_4_ingclass.yaml https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.5.4/v2_5_4_ingclass
kubectl apply -f v2_5_4_ingclass.yaml
```

Ingress 리소스 배포
```bash
kubectl apply -f ingress.yaml
kubectl apply -f ALM.yaml
kubectl apply -f PRO.yaml
```

Blackbox Exporter 설치
```bash
helm install blackbox-exporter prometheus-community/prometheus-blackbox-exporter -n monitoring
```

### 6.2 ArgoCD 설치 및 블루/그린 배포 설정
ArgoCD 설치
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

ArgoCD CLI 설치 (선택 사항)
```bash
cd ~/environment
VERSION=$(curl --silent "https://api.github.com/repos/argoproj/argo-cd/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')

sudo curl --silent --location -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/$VERSION/argocd-linux-amd64

sudo chmod +x /usr/local/bin/argocd
```

ArgoCD 서버 외부 노출

```bash
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

ArgoCD ELB 주소 확인
```bash
export ARGOCD_SERVER=`kubectl get svc argocd-server -n argocd -o json | jq --raw-output .status.loadBalancer.ingress[0].hostname`
echo $ARGOCD_SERVER
```

기본 관리자 비밀번호 조회
- 초기 접속 시 필요한 ELB 주소와 로그인 비밀번호를 확인합니다.
```bash
ARGO_PWD=`kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`
echo $ARGO_PWD
```

<img alt="argocd" width="1000" src="https://github.com/user-attachments/assets/b103681d-3940-407f-be91-e2d0fbe2c8c9" />
로그인 화면 

Argo Rollouts 설치 및 CLI 플러그인 구성
```bash
kubectl create secret generic mir-secret -n ecommerce \
  --from-literal=DD_CLIENT_TOKEN=$CLIENT_TOKEN \
  --from-literal=DD_APPLICATION_ID=$APPLICATION_ID \
  --from-literal=DD_SITE=us5.datadoghq.com \
  --from-literal=DD_SERVICE=mirapp \
  --from-literal=RAILS_DATABASE=spree_shop \
  --from-literal=RAILS_USERNAME=$USER \
  --from-literal=RAILS_PASSWORD=$PASSWORD \
  --from-literal=RAILS_HOST=mir-db.cd8yaap4uocm.ap-northeast-2.rds.amazonaws.com
```

Argo Rollouts 네임스페이스 생성

```bash
kubectl create namespace argo-rollouts
```

Install Argo Rollouts
```bash
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml
```


kubectl 플러그인 설치
```bash
curl -LO https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-linux-amd64
# Change File Permissions
chmod +x ./kubectl-argo-rollouts-linux-amd64
# Move the Binary to /usr/local/bin
sudo mv ./kubectl-argo-rollouts-linux-amd64 /usr/local/bin/kubectl-argo-rollouts
# Verify Installation
kubectl argo rollouts version

kubectl-argo-rollouts: v1.0.2+7a23fe5
  BuildDate: 2021-06-15T19:36:00Z
  GitCommit: 7a23fe5dbf78181248c48af8e5224246434e7f99
  GitTreeState: clean
  GoVersion: go1.16.3
  Compiler: gc
  Platform: linux/amd64

```

블루/그린 서비스 구성
```bash
cd ecommerce-workshop-k8s-manifest-Jo/base/frontend.yaml
```
Rollout 수동 승인 설정
롤아웃을 완료하기 전에 수동 승인이 필요하도록 하려면 autoPromotionEnabled 필드를 false로 설정
```bash
autoPromotionEnabled: false
```

롤아웃 자동 배포 설정
수동 승인 없이 자동 배포를 진행하려면 autoPromotionEnabled 필드를 true로 설정
```bash
autoPromotionEnabled: true
```


Rollout 리소스 구성

- apiVersion: apps/v1 대신 argoproj.io/v1alpha1를 사용합니다.
- kind: Deployment 대신 Rollout을 사용합니다.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  labels:
    tags.datadoghq.com/service: storefront
    app: ecommerce
    tags.datadoghq.com/env: "development"
  name: frontend
spec:
  replicas: 2
  revisionHistoryLimit: 2
  selector:
    matchLabels:
      tags.datadoghq.com/service: storefront
      tags.datadoghq.com/env: "development"
      app: ecommerce
  strategy:
    blueGreen: 
      # `activeService` is the previously deployed Blue service.
      activeService: frontend-rollout-bluegreen-active

      # `previewService` is the newly deployed Green service.
      previewService: frontend-rollout-bluegreen-preview

      # The `autoPromotionEnabled` option determines whether the rollout proceeds automatically.
      # Set to `false` for manual approval or `true` for automatic rollout.
      autoPromotionEnabled: true

  template:
    metadata:
      labels:
        tags.datadoghq.com/service: storefront
        tags.datadoghq.com/env: "development"
        app: ecommerce
    spec:
      containers:
      - args:
        - docker-entrypoint.sh
        command:
        - sh
        env:
        - name: DB_USERNAME
          value: user
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              key: pw
              name: db-password
        - name: DD_AGENT_HOST
          valueFrom:
            fieldRef:
              fieldPath: status.hostIP
        - name: DD_LOGS_INJECTION
          value: "true"
        - name: DD_ENV
          valueFrom:
            fieldRef:
              fieldPath: metadata.labels['tags.datadoghq.com/env']
        - name: DD_SERVICE
          valueFrom:
            fieldRef:
              fieldPath: metadata.labels['tags.datadoghq.com/service']
        - name: DD_ANALYTICS_ENABLED
          value: "true"
        - name: DISCOUNTS_ROUTE
          value: "http://discounts"
        - name: DISCOUNTS_PORT
          value: "5001"
        - name: ADS_ROUTE
          value: "http://advertisements"
        - name: ADS_PORT
          value: "5002"
        image: 822837196792.dkr.ecr.ap-northeast-2.amazonaws.com/frontend-ecr:826a72c4
        imagePullPolicy: Always
        name: ecommerce-spree-observability
        ports:
        - containerPort: 3000
          protocol: TCP
        resources:
          requests:
            cpu: 100m
            memory: 100Mi
          limits: {}
```

### 6.3 Datadog Agent 설치


Helm 저장소 추가 및 업데이트
```bash
helm repo add datadog https://helm.datadoghq.com
helm repo update
```

values.yaml 파일에 설정된 값으로 Helm을 사용해 Datadog을 monitoring 네임스페이스에 설치
```bash
cd /home/ubuntu/datadog
helm install datadog-monitoring -f values.yaml -n monitoring \
--set datadog.site={{ .Values.datadogSite }}' \
--set datadog.apiKey='{{ .Values.datadogApiKey }}'
```

<img alt="datadog_installed" width="1000" src="https://github.com/user-attachments/assets/f1dde7a5-e104-40e4-b3ec-44f8cd874a43" />

설치 완료 후 Datadog 에이전트가 클러스터에 정상 설치된 것을 확인합니다.



## 7. Testing & Results
### 7.1 블루/그린 배포 테스트


```bash
kubectl argo rollouts dashboard -n blue-green
```

<img alt="rollout_dashboard" width="800" src="https://github.com/user-attachments/assets/141d700b-567a-4597-afdc-0b6898bcad39" />

```bash
kubectl argo rollouts get rollout frontend
```

<img alt="rollout" width="800" src="https://github.com/user-attachments/assets/8bfa1182-340a-4236-8d5d-33f9fadb97ed" />

<img alt="rollout_ui" width="1000" src="https://github.com/user-attachments/assets/e3b43874-8518-4363-930e-191a1a2c43d6" />

- Argo Rollouts 대시보드 실행 후 frontend 리소스의 상태를 확인합니다.
<img alt="blue_green" width="1000" src="https://github.com/user-attachments/assets/e1a3ef9d-4f70-40d0-bbb2-764b5612a25e" />


ArgoCD UI에서 새로운 그린 환경(예: 크리스마스 광고 버전)으로의 배포 여부를 시각적으로 확인할 수 있습니다.

### 7.2 알림 테스트

<img alt="rollout_dashboard" width="800" src="https://github.com/user-attachments/assets/3b2c176b-01f3-4169-8d57-2a4c677e25ee" />

- advertisements Pod를 의도적으로 종료하여 장애 상황을 시뮬레이션합니다.
- Datadog의 Live Tail 기능을 통해 에러 로그를 실시간으로 감지하고 경고가 발생합니다.

<img alt="rollout_dashboard" width="800" src="https://github.com/user-attachments/assets/8d45c3a3-bb01-42a7-aef9-4dd36fe154eb" />

- Slack 채널로 장애 알림 메시지가 전송되며, Pod 관련 장애인 경우 AlertManager가 Gmail을 통해 이메일 알림을 전송합니다.


## 8. References
 [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
 
 [datadog-agent](https://docs.datadoghq.com/agent/?tab=Linux)

