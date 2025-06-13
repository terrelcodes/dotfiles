zsh loads the following, in order, if they exist:

file    | when
--------|------
/etc/zshenv        | always
$ZDOTDIR/.zshenv   | always
/etc/zprofile      | for login shells
$ZDOTDIR/.zprofile | for login shells
/etc/zshrc         | for interactive shells
$ZDOTDIR/.zshrc    | for interactive shells
/etc/zlogin        | for login shells
$ZDOTDIR/.zlogin   | for login shells
$ZDOTDIR/.zlogout  | just before exiting a login shell
/etc/zlogout       | just before exiting a login shell