# rock 5b [ubuntu22.04](https://github.com/Joshua-Riek/ubuntu-rockchip) 风扇控制

## 执行以下命令

```bash
cp fan_pwm_control.sh /usr/local/bin/
```

```bash
sudo chmod +x /usr/local/bin/fan_pwm_control.sh
```

```bash
cp fan_pwm.service /etc/systemd/system/
```

```bash
systemctl daemon-reload
```

```bash
systemctl start fan_pwm
```

```bash
systemctl enable fan_pwm
```
