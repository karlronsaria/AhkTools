import math
import numpy as np
import win32clipboard as clip

clip.OpenClipboard()
data = clip.GetClipboardData().strip().replace('\r\n', ' ')
clip.CloseClipboard()

print(eval(data), end='')
