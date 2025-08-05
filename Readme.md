# Configure CI/CD Pipeline: Jenkins + Ansible + Docker 

## ✅ PHASE 1: EC2 Instance Setup

### 🔹1. Create 2 EC2 Instances

* **Control Node**: Where Jenkins, Ansible, Docker will run.
* **Target Node**: Where the application will be deployed.
<img width="1335" height="249" alt="image" src="https://github.com/user-attachments/assets/18126dbd-1e0a-473b-b598-0326a2849305" />

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
<img width="887" height="607" alt="image" src="https://github.com/user-attachments/assets/788a7eb4-1801-4a2c-96b6-bfd30b7b287a" />


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
<img width="1072" height="153" alt="image" src="https://github.com/user-attachments/assets/70783abf-4fb3-4cb7-8384-c201661cfabe" />

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


### 🔹14. Create Pipeline Job in Jenkins

* Go to **Jenkins > New Item > Pipeline**
* Choose **Pipeline script from SCM**
* Use your GitHub URL

### 🔹15. Add DockerHub Credentials in Jenkins
* Go to **Jenkins > Manage Jenkins > Credentials > Global**
* Add **username + password/token** as **"DockerHub"**

### 🔹16. Run the Jenkins Pipeline

This should:

* Checkout the code
* Build the Docker image
* Copy or deploy to the Target EC2 using Ansible
* Start the app
* 
<img width="882" height="535" alt="image" src="https://github.com/user-attachments/assets/9d275e8f-4e73-43ac-ab04-7612783580b4" />


## ✅ PHASE 7: Verify Application

Access the deployed app:

```bash
http://<TargetNode-IP>
```
<img width="1081" height="71" alt="image" src="https://github.com/user-attachments/assets/829397a7-3ce1-4d60-9212-3bd2168485b7" />

<img width="685" height="208" alt="image" src="https://github.com/user-attachments/assets/173ab543-b7e6-4ac0-9934-b682f9abeb37" />

