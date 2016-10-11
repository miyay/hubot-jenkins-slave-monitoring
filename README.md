# Hubot Jenkins-Slave Monitoring

JenkinsSlaveマシンの死活監視を行います。

## Installation
### Add package.json

```
"dependencies": {
  "hubot-jenkins-slave-monitoring": "git://github.com/miyay/hubot-jenkins-slave-monitoring.git"
}
```

### Add external-scripts.json

```
[
  "hubot-jenkins-slave-monitoring"
]
```

### Configure (ENV vars)

```
export HUBOT_JENKINS_SLAVE_MONITORING_URL='http://localhost:8080'       # Jenkins-Master URL
export HUBOT_JENKINS_SLAVE_MONITORING_TARGET='{"(master)": "#general"}' # Slave name and notified channel
```

## Usage
### 定期チェック

5分に1回チェックを行い、オフラインになっていると通知が出ます。

### 手動チェック

即時チェックを行います。

```
hubot alive?
```
