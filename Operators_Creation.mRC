;Y Mod Creation List

on *:TEXT:!chatmods:#: {
  if ($nick == $mid(#,2) || ($nick == fonic_artes)) { msg # .mods }
}

on *:NOTICE:The moderators of this room are*:#: {
  var %i = $remove($7-, $chr(44))
  var %ops = $replace(%i, $chr(32), $crlf)
  var %owner = $mid(#,2)
  var %file = data\Operators_List\OP_List_ $+ $mid(#,2) $+ .txt

  write -c %file
  write %file %ops
  write %file %owner
}
