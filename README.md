# nssh
A extension for openssh-portable supporting "none" cipher and "none" MAC

## how to build
- `nssh` will be installed into `/opt/nssh`

```sh
./build.sh
```

## how to use
- sshd
  ```
  sudo /opt/nssh/sbin/sshd -f /opt/nssh/etc/sshd_config
  ```

- ssh
  ```
  /opt/nssh/bin/ssh -c none -m none -p 2222 ...
  ``` 

