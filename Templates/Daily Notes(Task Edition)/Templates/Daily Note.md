---
tag: dailies
cssclass: dashboard
---
## <% moment(tp.file.title, "YYYY-MM-DD").format("dddd Do MMMM YYYY") %>

<< [[<% fileDate = moment(tp.file.title, 'YYYY-MM-DD').subtract(1, 'd').format('YYYY-MM-DD') %>|Yesterday]] | [[<% fileDate = moment(tp.file.title, 'YYYY-MM-DD').add(1, 'd').format('YYYY-MM-DD') %>|Tomorrow]] >>

- > [!warning]+ [[Action Dashboard| OverDue ]]
> ```tasks
> not done
> sort by due date
> due before <% tp.date.now("YYYY-MM-DD") %>
> hide due date
> hide backlink
> limit 5
> ```

- > [!todo]+ Today's Tasks
> ```tasks
> not done
> due <% tp.date.now("YYYY-MM-DD") %>
> sort by path
> sort by priority
> hide due date
> hide backlink
> limit 5
> ```

- > [!Warning]+ Unscheduled Tasks  
 > ```tasks  
 > not done  
 > no due date

- > [!todo]+ Upcoming Tasks
> ```tasks  
> not done  
> due after <% tp.date.now("YYYY-MM-DD") %>  
> sort by due date
> sort by priority  

## [[Habit Tracker]]
> [!tip]+ Habit Tracker  
> Sleep:: 0  
> Reading:: 0  
> Exercise:: 0  
> Meditation:: 0  
> Writing:: 0


> [!success]+ Tasks Done Today
> ```tasks 
> done <% tp.date.now("YYYY-MM-DD") %>
>  hide due date
>  hide backlink
### New Tasks

