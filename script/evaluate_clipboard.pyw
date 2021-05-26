from numpy import *
import win32clipboard as clip

clip.OpenClipboard()
data = clip.GetClipboardData().strip().replace('\x00', '').replace('\r\n', ' ')
clip.CloseClipboard()

print(eval(data), end='')
