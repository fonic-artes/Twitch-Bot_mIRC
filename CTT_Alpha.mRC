;V Click-to-Tweet Generation
on *:text:!settweet*:#: {
  if ($nick == $mid(#,2) || $nick == fonic_artes) {
    var %encodedtweet = https://twitter.com/intent/tweet?text= $+ $urlencode($$2-)
    var -g %tweet_ [ $+ [ $mid(#,2) ] ] $tinyurl(%encodedtweet)
    msg # /me - Click-to-tweet URL: %tweet_ [ $+ [ $mid(#,2) ] ]
  }
  if (%status_ [ $+ [ $mid(#,2) ] ] == Online) {
    .timer[CTT_ [ $+ [ # ] ] $+ ] off
    .timer[CTT_ [ $+ [ # ] ] $+ ] 0 3600 msg # /me - Consider tweeting the stream to get more people in here to enjoy the show! %tweet_ [ $+ [ $mid(#,2) ] ]
  }
}

on *:text:!ctt:#: {
  var %displayName = $displayName($nick)
  if (%cttspam_ [ $+ [ $mid(#,2) ] ]) { halt }
  if (!%tweet_ [ $+ [ $mid(#,2) ] ]) { halt }
  if (%displayName && !%cttspam_ [ $+ [ $mid(#,2) ] ]) {
    set -u30 %cttspam_ $+ $mid(#,2) On
    msg # /me - Thanks for tweeting out the stream, %displayName $+ ! <3 %tweet_ [ $+ [ $mid(#,2) ] ]
  }
}

on *:text:!tweetoff:#: {
  if ($nick == $mid(#,2) || $nick == fonic_artes) {
    .timer[CTT_ [ $+ [ # ] ] $+ ] off
    msg # /me - Timed tweet disabled.
  }    
}
