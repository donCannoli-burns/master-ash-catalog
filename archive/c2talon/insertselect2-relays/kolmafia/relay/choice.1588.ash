import "relay/choice.ash"
import <insertSelect2.ash>

void main(string page_text_encoded)
{
	string page_text = page_text_encoded.choiceOverrideDecodePageText();

	page_text = insertSelect2(page_text,"width: '*'");

	//modify page_text in other ways here

	write(page_text);
}
