bash loads the following, in order, if they exist:

login shells:
   interactive:
    /etc/profile
    only the first that exists:
    - $HOME/.bash_profile
    - $HOME/.bash_login
    - $HOME/.profile
non-login shells:
/etc/bash.bashrc
$HOME/.bashrc