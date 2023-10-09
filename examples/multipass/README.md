# Apply Traditional Deployment to Local

1. Setup [Multipass](https://multipass.run/) instances.

  ```
  tf -chdir=setup init
  tf -chdir=setup apply -auto-approve

  ```

2. Apply traditional deployment, deliver a Java web application.

  ```
  tf init
  tf apply -auto-approve

  ```

3. Access the output endpoint.
