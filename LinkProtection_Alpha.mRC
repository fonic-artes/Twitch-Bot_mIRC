; LINK PROTECTION
on $*:text:*:#: {
  var %opsList = $read(data\Operators_List\Op_List_ [ $+ [ $mid(#,2) ] ] $+ .txt, nw, $nick)
  if (%links. [ $+ [ # ] ]) {
    if ($regex($1-,/.+\.(com|co|uk|net|org|gov|tv|edu|fm|ly|gl|rs|eu|gp|cc|tk|biz)/iS)) && (!%opsList) {
      if (!%permit. [ $+ [ $+($nick,_,#) ] ]) {
        msg # .timeout $nick 1
        msg # /me - Please, $displayName($nick) $+ , ask for permission before throwing a link out.
      }

      if (%permit. [ $+ [ $+($nick,_,#) ] ]) {
        unset %permit. [ $+ [ $+($nick,_,#) ] ]
      }
    }

    if ($1 == !permit) {
      if (!%opsList) { halt }
      set -u30 %permit. [ $+ [ $+($2,_,#) ] ] 1
      msg # /me - $displayName($2) $+ , you have 30 seconds to post a link.
    }
  }

  if ($1 == !links) {
    if (!%opsList) { halt }
    if ($2 == on) {
      set %links. $+ # On
      msg # /me - Link protection active.
    }
    if ($2 == off) {
      unset %links. $+ #
      msg # /me - Link protection disabled.
    }
  }
}
