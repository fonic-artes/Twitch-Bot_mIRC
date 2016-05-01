;I Command System
on *:text:!addcom*:#: {
  var %file = data\Commands\commands_ [ $+ [ $mid(#,2) ] ] $+ .ini
  var %opList = $read(data\Operators_List\Op_List_ [ $+ [ $mid(#,2) ] ] $+ .txt, nw, $nick)
  var %head = $mid($2,2)
  if (!%opList) { msg # /me - Only moderators are allowed to add commands. | halt }
  if ($2 == $null) { msg # /me - I can't add a command if there's nothing to add. Command Syntax. !addcom <!commandname> -<User Level(mod,owner,blank for all)> <response> | halt }
  if (!opList && $3 == -mod) { 
    var %level = Moderator
    writeini -n %file %head command $4-
    writeini -n %file %head level %level
    msg # /me - The command $2 has been added. Level permission - %level
  }

  if (%opList && $3 == -owner) { 
    var %level = Owner
    writeini -n %file %head command $4-
    writeini -n %file %head level %level
    msg # /me - The command $2 has been added. Level permission - %level
  }
  if (%opList && ($3 != -owner) && ($3 != -mod)) {
    var %level = Everyone
    writeini -n %file %head command $3-
    writeini -n %file %head level %level
    msg # /me - The command $2 has been added. Level permission - %level

  }
}
on $*:text:/^!(delcom|remcom)/iS:#: { 
  var %file = data\Commands\commands_ [ $+ [ $mid(#,2) ] ] $+ .ini
  var %command = $mid($2,2)
  var %section = $ini(%file,%command)
  var %opList = $read(data\Operators_List\Op_List_ [ $+ [ $mid(#,2) ] ] $+ .txt, nw, $nick)
  if (!%opList) { msg # /me - You cannot remove commands. | halt }
  if (%opList && (%section == $null)) { msg # /me - This command cannot be removed, as it doesn't exist. | halt }
  if (%opList && (%section != $null)) {
    remini %file %command
    msg # /me - The command $2 has been removed.
  }
}

on *:text:!editcom*:#: {
  var %file = data\Commands\commands_ [ $+ [ $mid(#,2) ] ] $+ .ini
  var %command = $mid($2,2)
  var %returned = $ini(%file,%command)
  var %opList = $read(data\Operators_List\Op_List_ [ $+ [ $mid(#,2) ] ] $+ .txt, nw, $nick)
  var %section = $ini(data\Commands\commands_ [ $+ [ $mid(#,2) ] ] $+ .ini,%returned)
  if (!%opList) { msg # /me - You cannot edit commands. | halt }
  if (%opList && (%returned == $null)) { halt }
  if (%opList && (%returned != $null)) {
    if (%opList && $3 == -mod) { 
      var %level = Moderator
      writeini -n %file %section command $4-
      writeini -n %file %section level %level
      msg # /me - The command $2 has been updated. Level permission - %level
    }

    if (%opList && $3 == -owner) { 
      var %level = Owner
      writeini -n %file %section command $4-
      writeini -n %file %section level %level
      msg # /me - The command $2 has been edited. Level permission - %level
    }
    if (%opList && ($3 != -owner) && ($3 != -mod)) {
      var %level = $readini(%file,n,%section,level)
      writeini -n %file %section command $3-
      msg # /me - The command $2 has been edited. Level permission - %level
    }
  }
}

on $*:text:/^!.*/iS:#: {
  var %file = data\Commands\commands_ [ $+ [ $mid(#,2) ] ] $+ .ini
  var %command = $mid($1,2)
  var %opList = $read(data\Operators_List\Op_List_ [ $+ [ $mid(#,2) ] ] $+ .txt, nw, $nick)
  var %rCommand = $readini(%file, n,%command,command)
  var %head = $ini(%file,%command)
  var %level = $readini(%file, n,%command,level)
  var %eCommand = $replace(%rcommand, @user, $displayName($nick), @target, $iif($followName($2), $followName($2),$2-))
  if (%flood. [ $+ [ $mid(#,2) ] $+ $1 $+ ]) { halt }
  if (%level == Moderator && %opList) { set -u5 %flood. $+ $mid($1,2) | msg # %eCommand }
  if (%level == Owner && $nick == $mid(#,2)) { set -u5 %flood. $+ $mid($1,2) | msg # %eCommand }
  if (%level == Everyone) { set -u5 %flood. $+ $mid($1,2) | msg # %eCommand }

}
