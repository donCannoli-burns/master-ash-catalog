import "relay/choice.ash"
import <c2t_peridot_relay.ash>

void main(string page_text_encoded)
{
	string page_text = page_text_encoded.choiceOverrideDecodePageText();
	page_text.c2t_peridot_relay().write();
}

