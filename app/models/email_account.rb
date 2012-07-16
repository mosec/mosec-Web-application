class EmailAccount < Source
	GMAIL = 'gmail'

	EMAIL_ACCOUNTS = [GMAIL]

	validates :provider, inclusion: { in: EMAIL_ACCOUNTS }
end