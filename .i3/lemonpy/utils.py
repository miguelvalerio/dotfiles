def set_fg_bg(text='', fg='#000000', bg='#FFFFFF'):
    return '%{{F{}}}%{{B{}}}{}'.format(fg, bg, text)
