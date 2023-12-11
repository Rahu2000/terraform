# NodeGroup

## **_THIS PAGE IS DEPRECATED_**

## Variable schema

| 항목                    | 필수구분 | 기본 값 | 설명                                                                                 |
| ----------------------- | -------- | ------- | ------------------------------------------------------------------------------------ |
| key                     | O        | ""      | 생성 대상의 node group. map. key.name 항목을 생략 할 경우 key 값으로 노드 그룹 생성  |
| key.name                | X        | ""      | node group 이름 </br>map에서 반드시 고유해야 한다. 생략 시. map의 Key 값이 설정된다. |
| key.use_spot            | X        | false   | SPOT 인스턴스 사용 여부. `true`로 설정 시 노드 그룹의 인스턴스 용량 유형은 `SPOT`    |
| key.instance_type       | X        | ""      | use_spot = `false`일 경우 필수. 인스턴스 유형                                        |
| key.spot_instance_types | X        | []      | use_spot = `true`일 경우 필수. 인스턴스 유형 목록                                    |
| key.instance_volume     | X        | 30      | GB                                                                                   |
| key.desired_size        | X        | 1       | auto scaling 설정. 노드 그룹의 인스턴스 수                                           |
| key.min_size            | X        | 1       | auto scaling 설정. 노드 그룹의 최소 인스턴스 수                                      |
| key.max_size            | X        | 2       | auto scaling 설정. 노드 그룹의 최대 인스턴스 수                                      |
| key.description         | X        | ""      | 노드 그룹에 대한 설명                                                                |
| key.labels              | X        | {}      | 노드에 추가 설정 할 labels                                                           |
| key.taints              | X        | []      | 노드에 설정 할 taints                                                                |
| key.kubelet_version     | X        | ""      | Kubelet 버전                                                                         |
| key.user_data_script    | X        | ""      | 스크립트 파일명. </br>또한 스크립트 파일은 반드시 `/templates/`폴더에 존재해야 한다. |

예제

```json
eks_node_groups = {
  ops = {
    "name"            = "ops"
    "instance_type"   = "t3.large"
    "instance_volume" = "30"
    "desired_size"    = 3
    "min_size"        = 3
    "max_size"        = 5
    "description"     = "for operations"
    "labels"          = {
      "role" = "ops"
    }
    "taints"          = []
    "user_data_script"= "example_enable_containerd.sh"
  }
  apps = {
    "name"            = "apps"
    "use_spot"        = true
    "instance_types"  = ["t3.large"]
    "instance_volume" = "30"
    "desired_size"    = 3
    "min_size"        = 3
    "max_size"        = 5
    "description"     = "for application"
    "labels"          = {
      "role" = "apps"
    }
    "user_data_script"= "example_enable_containerd.sh"
  }
}
```
