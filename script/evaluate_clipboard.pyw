import math
import win32clipboard as clip

clip.OpenClipboard()
data = clip.GetClipboardData()
clip.CloseClipboard()

print(eval(data), end='')
