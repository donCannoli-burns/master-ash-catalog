void main()
{
	buffer page_text = visit_url("campground.php?action=doghouse");
	if (page_text.contains_text("Board up the doghouse"))
		run_choice(5);
	else
		run_choice(6);
}