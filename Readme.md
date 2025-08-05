# Configure CI/CD Pipeline: Jenkins + Ansible + Docker 

## ✅ PHASE 1: EC2 Instance Setup

### 🔹1. Create 2 EC2 Instances

* **Control Node**: Where Jenkins, Ansible, Docker will run.
* **Target Node**: Where the application will be deployed.

### 🔹2. Security Group Configuration

Allow the following inbound ports for both:

* **22** – SSH
* **80** – HTTP (for web app)
* **8080** – Jenkins

---

## ✅ PHASE 2: Setup Control Node (Jenkins + Ansible + Docker)

### 🔹3. SSH into Control Node

```bash
ssh -i <your-key.pem> ubuntu@<ControlNode-IP>
```

### 🔹4. Install Jenkins
### 🔹5. Install Docker
### 🔹6. Install Ansible

---

## ✅ PHASE 3: Setup Target Node

### 🔹7. SSH into Target Node

```bash
ssh -i <your-key.pem> ubuntu@<TargetNode-IP>
```

### 🔹8. Set password for root

```bash
passwd root
```

### 🔹9. Enable Root SSH Access

Edit the sshd config:

```bash
sudo nano /etc/ssh/sshd_config
```

Change or add the following:

```
PermitRootLogin yes
PasswordAuthentication yes
```

Check the these file also if you face `Permission denied (publickey).`:

```bash
cat /etc/ssh/sshd_config.d/*.conf
```
Add the following:

```
PermitRootLogin yes
PasswordAuthentication yes
```


Then restart SSH:

```bash
sudo systemctl restart ssh
```

### 🔹10. Install Docker on Target Node

```bash
sudo apt update
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
```

---

## ✅ PHASE 4: Setup SSH Access for Ansible

### 🔹11. Back to Control Node

From the control node, verify SSH login to target using:

```bash
ssh root@<TargetNode-IP>
# enter password 
```

If successful, create the Ansible inventory:

```ini
# /etc/ansible/hosts or custom file
[target]
<target-node-ip> ansible_user=root ansible_ssh_pass=redhat 
```

### 🔹12. Test Ansible

```bash
ansible all --inventory inventory --list-hosts
ansible all --inventory inventory -m ping
```

---

## ✅ PHASE 5: Jenkins Setup

### 🔹13. Unlock Jenkins

Access Jenkins:
Go to `http://<control-node-ip>:8080`
Get initial password:

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Install suggested plugins. Create admin user.

---

### 🔹14. Create Pipeline Job in Jenkins

* Go to **Jenkins > New Item > Pipeline**
* Choose **Pipeline script from SCM**
* Use your GitHub URL

### 🔹15. Add DockerHub Credentials in Jenkins
* Go to **Jenkins > Manage Jenkins > Credentials > Global**
* Add **username + password/token** as **"DockerHub"**

---


### 🔹16. Run the Jenkins Pipeline

This should:

* Checkout the code
* Build the Docker image
* Copy or deploy to the Target EC2 using Ansible
* Start the app

---

## ✅ PHASE 7: Verify Application

Access the deployed app:

```bash
http://<TargetNode-IP>
```

