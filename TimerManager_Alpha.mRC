;C Timer Management

on *:JOIN:#: {
  if ($nick == $me) { 
    .timer[GAME_CHECK_ $+ $chan $+ ] 0 120 streamGameOnline $chan | streamGameOnline $chan
    .timer[STREAM_CHECK_ $+ $chan $+ ] 0 120 streamStatus $chan | streamStatus $chan
    msg # .mods
    .timer[MODLIST_ $+ $chan $+ ] 0 43200 msg # .mods
  }
}

on *:PART:#: {
  if ($nick == $me) {
    /timer[*_ $+ # $+ ] off
  }
}

on *:TEXT:!part:#: {
  if ($nick == $mid(#,2) || ($nick == fonic_artes)) {
    /part #
  }
}
