node:
  serviceAccount:
    create: false
    name: ${service_account_name}

%{if resources != "" ~}
  resources:
    ${indent(4, resources)}
%{ endif ~}