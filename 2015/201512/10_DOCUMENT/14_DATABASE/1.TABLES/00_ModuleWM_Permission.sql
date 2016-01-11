--- Created by Bao Anh	Date: 11/09/2012
--- Purpose: Xoa phan quyen cho 'WF0078','WF0079','WF0080','WF0081' (do truoc day lam cho ton kho theo vi tri nhung tinh nang nay khong dung nua)

Delete AT1404STD Where ScreenID in ('WF0078','WF0079','WF0080','WF0081','WF0082')
Delete AT1403STD Where ScreenID in ('WF0078','WF0079','WF0080','WF0081','WF0082')
DELETE A00004STD WHERE ScreenID in ('WF0078','WF0079','WF0080','WF0081','WF0082')
