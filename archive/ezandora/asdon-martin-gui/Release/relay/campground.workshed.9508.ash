import "relay/AsdonMartinGUI.ash"

void main()
{
	if (get_campground()[$item[Asdon Martin keyfob (on ring)]] > 0)
		handleRelayRequest();
	else
		write(visit_url());
}