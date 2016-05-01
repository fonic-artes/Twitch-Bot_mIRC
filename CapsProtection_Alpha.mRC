; CAPS PROTECTION

on $@*:text:*:#:{
  var %opsList = $read(data\Operators_List\Op_List_ [ $+ [ $mid(#,2) ] ] $+ .txt, nw, $nick)
  if ($1 == !caps) {
    if (!%opsList) { halt }
    if ($2 == on) {
      set %caps. $+ # On
      msg # /me - Caps protection active.
    }
    if ($2 == off) {
      unset %caps. $+ #
      msg # /me - Caps protection disabled.
    }
  }

  if (%caps. [ $+ [ # ] ]) {
    if (%opsList) { halt }
    if (( $len($1-) >= 10 ) && ( $calc($regex($1-,/[A-Z]/g) / $regex($1-,/[A-Z]/gi) * 100) >= 70 )) {
      msg # /me - $displayName($nick) $+ , relax on the caps mate.
      msg # .timeout $nick 1
    }
  }
}