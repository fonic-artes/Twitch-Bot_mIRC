;J Quote System
on *:text:!addquote*:#: {
  var %game = $streamGame($mid(#,2))
  var %quote = $2-
  var %head = $ctime
  var %displayName = $displayName($nick)
  var %file = data\Quotes\quotes_ [ $+ [ $mid(#,2) ] ] $+ .ini
  if ($2 == $null) { msg # /me - You gotta have context to add a quote. }
  if (%status_ [ $+ [ $mid(#,2) ] ] == Offline) { msg # /me - You cannot add quotes while the stream is offline. }
  if (%status_ [ $+ [ $mid(#,2) ] ] == Online) {
    /writeini -n %file %head quote %quote
    /writeini -n %file %head game %game
    /writeini -n %file %head addedby %displayName
    msg # /me - Quote $chr(35) $+ $ini(%file,0) has been added to the list.
  }
}


on $*:text:/^!(delquote|remquote)/iS:#: {
  var %opList = $read(data\Operators_List\Op_List_ [ $+ [ $mid(#,2) ] ] $+ .txt, nw, $nick)
  var %tQuotes = $ini(data\Quotes\quotes_ [ $+ [ $mid(#,2) ] ] $+ .ini,0)
  var %file = data\Quotes\quotes_ [ $+ [ $mid(#,2) ] ] $+ .ini
  var %section = $ini(data\Quotes\quotes_ [ $+ [ $mid(#,2) ] ] $+ .ini,$2)
  if (!%opList) { msg # /me - You are not allowed to delete quotes. | halt }
  if ($2 == $null) { msg # /me - Delete a quote? Which one, you gotta specify. | halt }
  if ($2 > %tQuotes) { msg # /me - I can't delete quotes when they don't exist. | halt }
  if (%opList) {
    remini %file %section
    msg # /me - Quote $chr(35) $+ $2 has been successfully deleted.
  }
}
on *:text:!editquote*:#: {
  var %opList = $read(data\Operators_List\Op_List_ [ $+ [ $mid(#,2) ] ] $+ .txt, nw, $nick)
  if (!%opList) { msg # /me - You are not allowed to edit quotes. }
  if ($2 > $ini(data\Quotes\quotes_ $+ $mid(#,2) $+ .ini,0)) { msg # /me - Hard to edit a quote when it doesn't exist. | halt }
  if (%oplist) {
    var %eQuote = $3-
    var %file = data\Quotes\quotes_ [ $+ [ $mid(#,2) ] ] $+ .ini
    var %qNum = $ini(data\Quotes\quotes_ [ $+ [ $mid(#,2) ] ] $+ .ini,$2)
    /writeini -n %file %qNum quote %eQuote
    /writeini -n %file %qNum editedby $follow($nick)
    msg # /me - Quote $chr(35) $+ $2 has been edited.
  }
}

on *:text:!infoquote*:#: {
  var %opList = $read(data\Operators_List\Op_List_ [ $+ [ $mid(#,2) ] ] $+ .txt, nw, $nick)
  if (%flood_QuotesInfo_ [ $+ [ # ] ]) { halt }
  if (!%oplist) { msg # /me - You are not allowed to view the info of the quotes. }
  if ($2 > $ini(data\Quotes\quotes_ $+ $mid(#,2) $+ .ini,0)) { msg # /me - Seems that we don't have any information for an imaginary quote. | halt }
  if (%oplist) {
    set -u600 %flood_QuoteInfo_ $+ # On
    if ($ini(data\Quotes\quotes_ $+ $mid(#,2) $+ .ini,$2,editedby) == $null) {
      var %qNum = $ini(data\Quotes\quotes_ $+ $mid(#,2) $+ .ini,$2)
      msg # /me - Information for Quote $chr(35) $+ $2 $+ : Quote: " $+ $readini(data\Quotes\quotes_ [ $+ [ $mid(#,2) ] ] $+ .ini,n,%qNum,quote) $+ " - Game: $readini(data\Quotes\quotes_ [ $+ [ $mid(#,2) ] ] $+ .ini,n,%qNum,game) - Added By: $readini(data\Quotes\quotes_ [ $+ [ $mid(#,2) ] ] $+ .ini,n,%qNum,addedby) - Date Added: $asctime(%qNum,dd/mm/yyyy)
    }
    if ($ini(data\Quotes\quotes_ $+ $mid(#,2) $+ .ini,$2,editedby) != $null) {
      var %qNum = $ini(data\Quotes\quotes_ $+ $mid(#,2) $+ .ini ,$2)
      msg # /me - Information for Quote $chr(35) $+ $2 $+ : Quote: " $+ $readini(data\Quotes\quotes_ [ $+ [ $mid(#,2) ] ] $+ .ini,n,%qNum,quote) $+ " - Game: $readini(data\Quotes\quotes_ [ $+ [ $mid(#,2) ] ] $+ .ini,n,%qNum,game) - Added By: $readini(data\Quotes\quotes_ [ $+ [ $mid(#,2) ] ] $+ .ini,n,%qNum,addedby) - Edited By: $readini(data\Quotes\quotes_ [ $+ [ $mid(#,2) ] ] $+ .ini,n,%qNum,editedby) - Date Added: $asctime(%qNum,dd/mm/yyyy)
    }
  }
}
on *:text:!quote*:#: {
  if (%flood_Quote_ [ $+ [ # ] ]) { halt }
  if (!$ini(data\Quotes\quotes_ $+ $mid(#,2) $+ .ini,0)) { halt }
  if ($2 !isnum) { halt }
  if (($2 == $null) && ($1 == !quote)) {
    set -u60 %flood_Quote_ $+ # On
    var %totalQuotes = $ini(data\Quotes\quotes_ $+ $mid(#,2) $+ .ini,0)
    var %randQuote = $rand(1,%totalQuotes)
    var %quoteTopic = $ini(data\Quotes\quotes_ $+ $mid(#,2) $+ .ini,%randQuote)
    msg # /me - Quote $chr(35) $+ %randQuote $+ : " $+ $readini(data\Quotes\quotes_ [ $+ [ $mid(#,2) ] ] $+ .ini,n,%quoteTopic,quote) $+ " $+([,$readini(data\Quotes\quotes_ [ $+ [ $mid(#,2) ] ] $+ .ini,n,%quoteTopic,game),])
  }

  if ($2 != $null) {
    set -u60 %flood_Quote_ $+ # On
    if ($2 == 0) { halt }
    if ($2 > $ini(data\Quotes\quotes_ $+ $mid(#,2) $+ .ini,0)) { msg # /me - There's no quote there, last quote is $ini(data\Quotes\quotes $+ $mid(#,2) $+ .ini,0) $+ . Please try again. | halt }
    var %quoteTopic = $ini(data\Quotes\quotes_ $+ $mid(#,2) $+ .ini,$2)
    msg # /me - Quote $chr(35) $+ $2 $+ : " $+ $readini(data\Quotes\quotes_ [ $+ [ $mid(#,2) ] ] $+ .ini,n,%quoteTopic,quote) $+ " $+([,$readini(data\Quotes\quotes_ [ $+ [ $mid(#,2) ] ] $+ .ini,n,%quoteTopic,game),])
  }

  if ($1 == !quotes) {
    set -u60 %flood_Quote_ $+ # On
    var %qTotals = $ini(data\Quotes\quotes_ [ $+ [ $mid(#,2) ] ] $+ .ini,0)
    msg # /me - There are %qTotals quotes in the system.
  }
}

on *:text:!lastquote:#: {
  if (%flood_Quote_ [ $+ [ # ] ]) { halt }
  var %qTotals = $ini(data\Quotes\quotes_ [ $+ [ $mid(#,2) ] ] $+ .ini,0)
  var %qLast = $ini(data\Quotes\quotes_ [ $+ [ $mid(#,2) ] ] $+ .ini,%qTotals)
  set -u60 %flood_Quote_ $+ # On
  msg # /me - The last quote was $chr(35) $+ %qTotals $+ : " $+ $readini(data\Quotes\quotes_ [ $+ [ $mid(#,2) ] ] $+ .ini,n,%qLast,quote) $+ " $+([,$readini(data\Quotes\quotes_ [ $+ [ $mid(#,2) ] ] $+ .ini,n,%qLast,game),])
}
