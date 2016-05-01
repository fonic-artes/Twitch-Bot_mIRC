;D Join Other Channels & Mod List
on *:text:!join:#jacquesdusalt: {
  var %file = data\Channels\channel_list.txt
  join $chr(35) $+ $nick
  write %file $chr(35) $+ $nick
  msg # /me - Joining $displayName($nick) $+ 's channel, to allow all features please do /mod $me $+ .
  msg $chr(35) $+ $nick / me - I've joined the channel, awaiting further orders.  Please be sure to mod me for all features.
  msg $chr(35) $+ $nick .mods
}