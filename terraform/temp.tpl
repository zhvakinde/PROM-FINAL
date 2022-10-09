
all:
  children:
    app:
      hosts:
        ${appn1}:
          ansible_host: ${appip1}
        ${appn2}:
          ansible_host: ${appip2}
