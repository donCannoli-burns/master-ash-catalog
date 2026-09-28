void main()
{
	string [int] monster_image_names;
	boolean [string] seen_images;
	foreach m in $monsters[]
	{
		if (m.image.length() > 0 && !(seen_images contains m.image))
		{
			monster_image_names[monster_image_names.count()] = m.image; //"images/adventureimages/" + 
			seen_images[m.image] = true;
		}
	}
	map_to_file(monster_image_names, "list of monster image names.txt");
	print_html("Done.");
}