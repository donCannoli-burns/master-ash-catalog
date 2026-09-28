void main(string arguments)
{
	if (my_id() <= 0 || my_hash() == "")
	{
		cli_execute("login " + arguments);
	}
}