	<h3 id="remote_login_heading" align="left">Enter Login Information for <%=#{@sitename}%></h3>
	<table border="0" cellspacing="5" cellpadding="5" width="500">
		<tr>
			<td>Username: </td>
			<td> <%=text_field_tag 'username'%></td>
		</tr>
		<tr>
			<td>Password: </td>
			<td> <%=password_field_tag 'password'%></td>
		</tr>
	</table>