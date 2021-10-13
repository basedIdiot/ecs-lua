--[[
	ECS-Lua v2.0.0 [2021-10-02 17:25]

	ECS-Lua is a tiny and easy to use ECS (Entity Component System) engine for
	game development

	This is a minified version of ECS-Lua, to see the full source code visit
	https://github.com/nidorx/roblox-ecs

	------------------------------------------------------------------------------

	MIT License

	Copyright (c) 2021 Alex Rodin

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
]]
local a,b={},{}local function c(d)if(not a[d])then a[d]={r=b[d]()}end return a[d].r end b["Archetype"]=function()local d={}local e={}local f={}local g=0 local h={}h.__index=h function h.Of(i)local j={}local k={}for m,n in ipairs(i)do if(n.IsCType and not n.isComponent)then if n.IsQualifier then if k[n]==nil then k[n]=true table.insert(j,n.Id)end n=n.SuperClass end if k[n]==nil then k[n]=true table.insert(j,n.Id)end end end table.sort(j)local l='_'..table.concat(j,'_')if d[l]==nil then d[l]=setmetatable({id=l,_components=k},h)g=g+1 end return d[l]end function h.Version()return g end function h:Has(i)return(self._components[i]==true)end function h:With(i)if self._components[i]==true then return self end local j=e[self]if not j then j={}e[self]=j end local k=j[i]if k==nil then local l={i}for m,n in pairs(self._components)do table.insert(l,m)end k=h.Of(l)j[i]=k end return k end function h:WithAll(i)local j={}for k,l in pairs(self._components)do table.insert(j,k)end for k,l in ipairs(i)do if self._components[l]==nil then table.insert(j,l)end end return h.Of(j)end function h:Without(i)if self._components[i]==nil then return self end local j=f[self]if not j then j={}f[self]=j end local k=j[i]if k==nil then local l={}for m,n in pairs(self._components)do if m~=i then table.insert(l,m)end end k=h.Of(l)j[i]=k end return k end function h:WithoutAll(i)local j={}for l,m in ipairs(i)do j[m]=true end local k={}for l,m in pairs(self._components)do if j[l]==nil then table.insert(k,l)end end return h.Of(k)end h.EMPTY=h.Of({})return h end b["Component"]=function()local d=c("Utility")local e=c("ComponentFSM")local f=d.copyDeep local g=d.mergeDeep local h=0 local function i(l,m)h=h+1 local n={Id=h,IsCType=true,SuperClass=m}n.__index=n if m==nil then m=n m._Qualifiers={["Primary"]=n}m._Initializers={}else n.IsQualifier=true end local o=m._Qualifiers setmetatable(n,{__call=function(p,q)return n.New(q)end,__index=function(p,q)if(q=='States')then return m.__States end if(q=='Case'or q=='StateInitial')then return rawget(m,q)end end,__newindex=function(p,q,r)if(q=='Case'or q=='States'or q=='StateInitial')then if n==m then if(q=='States')then if not m.IsFSM then e.AddCapability(m,r)for s,t in pairs(o)do if t~=m then e.AddMethods(m,t)end end end else rawset(p,q,r)end end else rawset(p,q,r)end end})if m.IsFSM then e.AddMethods(m,n)end function n.Qualifier(p)if type(p)~="string"then for r,s in pairs(o)do if s==p then return p end end return nil end local q=o[p]if q==nil then q=i(l,m)o[p]=q end return q end function n.Qualifiers(...)local p={}local q={...}if#q==0 then for r,s in pairs(o)do table.insert(p,s)end else local r={}for s,t in ipairs({...})do local u=n.Qualifier(t)if u and r[u]==nil then r[u]=true table.insert(p,u)end end end return p end function n.New(p)if(p~=nil and type(p)~='table')then p={value=p}end local q=setmetatable(l(p)or{},n)for r,s in ipairs(m._Initializers)do s(q)end q.isComponent=true q._qualifiers={[n]=q}return q end function n:GetType()return n end function n:Is(p)return p==n or p==m end function n:Primary()return self._qualifiers[m]end function n:Qualified(p)return self._qualifiers[n.Qualifier(p)]end function n:QualifiedAll()local p={}for q,r in pairs(o)do p[q]=self._qualifiers[r]end return p end function n:Merge(p)if self==p then return end if self._qualifiers==p._qualifiers then return end if not p:Is(m)then return end local q=n local r=p:GetType()local s if q==m then s=self._qualifiers elseif r==m then s=p._qualifiers elseif self._qualifiers[m]~=nil then s=self._qualifiers[m]._qualifiers elseif p._qualifiers[m]~=nil then s=p._qualifiers[m]._qualifiers end if s~=nil then if self._qualifiers~=s then for t,u in pairs(self._qualifiers)do if m~=t then s[t]=u u._qualifiers=s end end end if p._qualifiers~=s then for t,u in pairs(p._qualifiers)do if m~=t then s[t]=u u._qualifiers=s end end end else for t,u in pairs(p._qualifiers)do if q~=t then self._qualifiers[t]=u u._qualifiers=self._qualifiers end end end end return n end local function j(l)return l or{}end local k={}function k.Create(l)local m=j if l~=nil then local n=type(l)if(n=='function')then m=l else if(n~='table')then l={value=l}end m=function(o)local p=f(l)if(o~=nil)then g(p,o)end return p end end end return i(m,nil)end return k end b["ComponentFSM"]=function()local function d(f,g)local h=g.States local i=g.IsSuperClass local j=g.ComponentClass if i then local k=j.Qualifiers()for l,m in ipairs(k)do local n=f[m]if(n~=nil and h[n:GetState()]==true)then return true end end return false else local k=f[j]if k==nil then return false end return h[k:GetState()]==true end end local e={}function e.AddCapability(f,g)f.IsFSM=true local h=setmetatable({},{__newindex=function(i,j,k)if(type(k)~="table")then k={k}end if table.find(k,'*')then rawset(i,j,'*')else local l=table.find(k,j)if l~=nil then table.remove(k,l)if#k==0 then k='*'end end rawset(i,j,k)end end})rawset(f,'__States',h)for i,j in pairs(g)do if f.StateInitial==nil then f.StateInitial=i end h[i]=j end e.AddMethods(f,f)table.insert(f._Initializers,function(i)i:SetState(f.StateInitial)end)end function e.AddMethods(f,g)local h=f.States function g.In(...)local i={}local j=0 for k,l in ipairs({...})do if(h[l]~=nil and i[l]==nil)then j=j+1 i[l]=true end end if j==0 then return{Components={g},}end return{Filter=d,Components={g},Config={States=i,IsSuperClass=(g==f),ComponentClass=g,}}end function g:SetState(i)if(i==nil or h[i]==nil)then return end local j=self:GetState()if(j==i)then return end if(j~=nil)then local l=h[j]if(l~='*'and table.find(l,i)==nil)then return end end self._state=i self._statePrev=j self._stateTime=os.clock()local k=f.Case and f.Case[i]if k then k(self,j)end end function g:GetState()return self._state or f.StateInitial end function g:GetPrevState()return self._statePrev or nil end function g:GetStateTime()return self._stateTime or 0 end end return e end b["ECS"]=function()local d=c("Query")local e=c("World")local f=c("System")local g=c("Archetype")local h=c("Component")local function i(k)e.LoopManager=k end pcall(function()if(game and game.ClassName=='DataModel')then i(c("RobloxLoopManager")())end end)local j={Query=d,World=e.New,System=f.Create,Archetype=g,Component=h.Create,SetLoopManager=i}if _G.ECS==nil then _G.ECS=j else local k=_G.warn or print k("ECS Lua was not registered in the global variables, there is already another object registered.")end return j end b["Entity"]=function()local d=c("Archetype")local e=0 local function f(j,k)if(k.IsCType)then return j._data[k]end local l=k local m={}local n=j._data for o,p in ipairs(l)do local q=n[p]if q then table.insert(m,q)end end return m end local function g(j,k,l)local m=j._data local n=j.archetype local o=n if k.isComponent then local p=k k=p:GetType()m[k]=p o=o:With(k)elseif k.IsCType then if(l==nil)then m[k]=nil o=o:Without(k)else if(type(l)=='table'and l.isComponent)then k=l:GetType()m[k]=l else m[k]=k(l)end o=o:With(k)end elseif#k>0 then local p=k[1]if p.isComponent then for q,r in ipairs(k)do if(r.isComponent)then k=r:GetType()m[k]=r o=o:With(k)end end else local q=k local r=l if(r==nil)then r={}end for s,t in ipairs(q)do if(t.IsCType)then local u=r[s]if u==nil then m[t]=nil o=o:Without(t)elseif(u.isComponent)then t=u:GetType()m[t]=u o=o:With(t)else m[t]=t(u)o=o:With(t)end end end end end if(n~=o)then j.archetype=o j._onChange:Fire(j,n)end end local function h(j,k)local l=j._data local m=j.archetype local n=m if k.isComponent then local o=k k=o:GetType()l[k]=nil n=n:Without(k)elseif k.IsCType then l[k]=nil n=n:Without(k)else local o=k for p,q in ipairs(o)do if q.isComponent then k=q:GetType()l[k]=nil n=n:Without(k)elseif q.IsCType then k=q l[k]=nil n=n:Without(k)end end end if j.archetype~=n then j.archetype=n j._onChange:Fire(j,m)end end local i={__index=function(j,k)if(type(k)=="table")then return f(j,k)end end,__newindex=function(j,k,l)local m=true if(type(k)=="table")then if(k.IsCType or k.isComponent)then g(j,k,l)elseif#k>0 then local n=k[1]if(type(n)=="table"and(n.IsCType))then g(j,k,l)else rawset(j,k,l)end else rawset(j,k,l)end else rawset(j,k,l)end end}function i.New(j,k)local l=d.EMPTY local m={}if(k~=nil and#k>0)then local n={}for o,p in ipairs(k)do local q=p:GetType()table.insert(n,q)m[q]=p end l=d.Of(n)end e=e+1 return setmetatable({_data=m,_onChange=j,id=e,isAlive=false,archetype=l,Get=f,Set=g,Unset=h,},i)end return i end b["EntityRepository"]=function()local d={}d.__index=d function d.New()return setmetatable({_archetypes={},_entitiesArchetype={},},d)end function d:Insert(e)if(self._entitiesArchetype[e]==nil)then local f=e.archetype local g=self._archetypes[f]if(g==nil)then g={Count=0,Entities={}}self._archetypes[f]=g end g.Entities[e]=true g.Count=g.Count+1 self._entitiesArchetype[e]=f else self:Update(e)end end function d:Remove(e)local f=self._entitiesArchetype[e]if f==nil then return end self._entitiesArchetype[e]=nil local g=self._archetypes[f]if(g~=nil and g.Entities[e]==true)then g.Entities[e]=nil g.Count=g.Count-1 if(g.Count==0)then self._archetypes[f]=nil end end end function d:Update(e)local f=self._entitiesArchetype[e]if(f==nil or f==e.archetype)then return end self:Remove(e)self:Insert(e)end function d:Query(e)local f={}for g,h in pairs(self._archetypes)do if e:Match(g)then table.insert(f,h.Entities)end end return e:Result(f)end return d end b["Event"]=function()local d={}d.__index=d function d.New(f,g)return setmetatable({_Event=f,_Handler=g},d)end function d:Disconnect()local f=self._Event if(f and not f.destroyed)then local g=table.find(f._handlers,self._Handler)if g~=nil then table.remove(f._handlers,g)end end setmetatable(self,nil)end local e={}e.__index=e function e.New()return setmetatable({_handlers={}},e)end function e:Connect(f)if(type(f)=="function")then table.insert(self._handlers,f)return d.New(self,f)end error(("Event:Connect(%s)"):format(typeof(f)),2)end function e:Fire(...)if not self.destroyed then for f,g in ipairs(self._handlers)do g(table.unpack({...}))end end end function e:Destroy()setmetatable(self,nil)self._handlers=nil self.destroyed=true end return e end b["Query"]=function()local d=c("QueryResult")local e={}local f={}f.__index=f setmetatable(f,{__call=function(i,j,k,l)return f.New(j,k,l)end,})local function g(i,j,k)local l={}local m={}local n={}for o,p in ipairs(i)do if(l[p]==nil)then if(p.IsCType and not p.isComponent)then l[p]=true table.insert(m,p)table.insert(n,p.Id)else if p.Components then l[p]=true for q,r in ipairs(p.Components)do if(not l[r]and r.IsCType and not r.isComponent)then l[r]=true table.insert(m,r)table.insert(n,p.Id)end end end if p.Filter then l[p]=true p[j]=true table.insert(k,p)end end end end if#m>0 then table.sort(n)local o='_'..table.concat(n,'_')return m,o end end function f.New(i,j,k)local l={}local m,n,o if(j~=nil)then j,m=g(j,"IsAnyFilter",l)end if(i~=nil)then i,n=g(i,"IsAllFilter",l)end if(k~=nil)then k,o=g(k,"IsNoneFilter",l)end return setmetatable({isQuery=true,_any=j,_all=i,_none=k,_anyKey=m,_allKey=n,_noneKey=o,_cache={},_clauses=#l>0 and l or nil,},f)end function f:Result(i)return d.New(i,self._clauses)end function f:Match(i)local j=self._cache local k=j[i]if k~=nil then return k else local l=e[i]if(l==nil)then l={Any={},All={},None={}}e[i]=l end local m=self._noneKey if m then local p=l.None[m]if(p==nil)then p=true for q,r in ipairs(self._none)do if i:Has(r)then p=false break end end l.None[m]=p end if(p==false)then j[i]=false return false end end local n=self._anyKey if n then local p=l.Any[n]if(p==nil)then p=false if(l.All[n]==true)then p=true else for q,r in ipairs(self._any)do if i:Has(r)then p=true break end end end l.Any[n]=p end if(p==false)then j[i]=false return false end end local o=self._allKey if o then local p=l.All[o]if(p==nil)then local q=true for r,s in ipairs(self._all)do if(not i:Has(s))then q=false break end end if q then p=true else p=false end l.All[o]=p end j[i]=p return p end j[i]=true return true end end local function h()local i={isQueryBuilder=true}function i.All(...)i._all={...}return i end function i.Any(...)i._any={...}return i end function i.None(...)i._none={...}return i end function i.Build()return f.New(i._all,i._any,i._none)end return i end function f.All(...)return h().All(...)end function f.Any(...)return h().Any(...)end function f.None(...)return h().None(...)end return f end b["QueryResult"]=function()local function d(l,m,n)return m,(l(m)==true),true end local function e(l,m,n)return l(m),true,true end local function f(l,m,n)local o=(n<=l)return m,o,o end local function g(l,m,n)local o=true for p,q in ipairs(l)do if(q.Filter(m,q.Config)==true)then o=false break end end return m,o,true end local function h(l,m,n)local o=true for p,q in ipairs(l)do if(q.Filter(m,q.Config)==false)then o=false break end end return m,o,true end local function i(l,m,n)local o=false for p,q in ipairs(l)do if(q.Filter(m,q.Config)==true)then o=true break end end return m,o,true end local j={}local k={}k.__index=k function k.New(l,m)local n=j if(m and#m>0)then local o={}local p={}local q={}n={}for r,s in ipairs(m)do if s.IsNoneFilter then table.insert(q,s)elseif s.IsAnyFilter then table.insert(p,s)else table.insert(o,s)end end if(#q>0)then table.insert(n,{g,q})end if(#o>0)then table.insert(n,{h,o})end if(#p>0)then table.insert(n,{i,p})end end return setmetatable({chunks=l,_pipeline=n,},k)end function k:With(l,m)local n={}for o,p in ipairs(self._pipeline)do table.insert(n,p)end table.insert(n,{l,m})return setmetatable({chunks=self.chunks,_pipeline=n,},k)end function k:Filter(l)return self:With(d,l)end function k:Map(l)return self:With(e,l)end function k:Limit(l)return self:With(f,l)end function k:AnyMatch(l)local m=false self:Run(function(n)if l(n)then m=true end return m end)return m end function k:AllMatch(l)local m=true self:Run(function(n)if(not l(n))then m=false end return m==false end)return m end function k:FindAny()local l self:Run(function(m)l=m return true end)return l end function k:ForEach(l)self:Run(function(m)return l(m)==true end)end function k:ToArray()local l={}self:Run(function(m)table.insert(l,m)end)return l end function k:Iterator()local l=coroutine.create(function()self:Run(function(m,n)coroutine.yield(m,n)end)end)return function()local m,n,o=coroutine.resume(l)return o,n end end function k:Run(l)local m=1 local n=self._pipeline local o=#n>0 if(not o)then for p,q in ipairs(self.chunks)do for r,s in pairs(q)do if(l(r,m)==true)then return end m=m+1 end end else for p,q in ipairs(self.chunks)do for r,s in pairs(q)do local t=false local u=true local v=r if(u and o)then for w,x in ipairs(n)do local y,z,A=x[1](x[2],v,m)if(not A)then t=true end if z then v=y else u=false break end end end if u then if(l(v,m)==true)then return end m=m+1 end if t then return end end end end end return k end b["RobloxLoopManager"]=function()local function d()local e=game:GetService('RunService')return{Register=function(f)local g=e.Stepped:Connect(function()f:Update('process',os.clock())end)local h=e.Heartbeat:Connect(function()f:Update('transform',os.clock())end)local i if(not e:IsServer())then i=e.RenderStepped:Connect(function()f:Update('render',os.clock())end)end return function()g:Disconnect()g:Disconnect()g:Disconnect()end end}end return d end b["System"]=function()local d=0 local e={'task','render','process','transform'}local f={}function f.Create(g,h,i,j)if(g==nil or not table.find(e,g))then error('The "step" parameter must one of ',table.concat(e,', '))end if type(h)=="function"then j=h h=nil end if(h==nil or h<0)then h=50 end if type(i)=="function"then j=i i=nil end if(i and i.isQueryBuilder)then i=i.Build()end d=d+1 local k=d local l={Id=k,Step=g,Order=h,Query=i,}l.__index=l function l.New(m,n)local o=setmetatable({version=0,_world=m,_config=n,},l)if o.Initialize then o:Initialize(n)end return o end function l:GetType()return l end function l:Result(m)return self._world:Exec(m or l.Query)end function l:Destroy()if self.OnDestroy then self.OnDestroy()end setmetatable(self,nil)for m,n in pairs(self)do self[m]=nil end end if j and type(j)=="function"then l.Update=j end return l end return f end b["SystemExecutor"]=function()local function d(i)local j={}local k={}for l,m in ipairs(i)do local n=m:GetType()if(m._TaskState==nil)then m._TaskState="suspended"end if not k[n]then local o={Type=n,System=m,Depends={}}k[n]=o table.insert(j,o)end end for l,m in ipairs(j)do local n=m.Type.Before if(n~=nil and#n>0)then for p,q in ipairs(n)do local r=k[q]if r then r.Depends[m]=true end end end local o=m.Type.After if(o~=nil and#o>0)then for p,q in ipairs(o)do local r=k[q]if r then m.Depends[r]=true end end end end return j end local function e(i,j)return i.Order<j.Order end local f={}f.__index=f function f.New(i,j)local k={}local l={}local m={}local n={}local o={}local p={}local q={}for r,s in pairs(j)do local t=s.Step if s.Update then if t=='task'then table.insert(n,s)elseif t=='process'then table.insert(p,s)elseif t=='transform'then table.insert(q,s)elseif t=='render'then table.insert(o,s)end end if(s.Query and s.Query.isQuery and t~='task')then if s.OnExit then table.insert(k,s)end if s.OnEnter then table.insert(l,s)end if s.OnRemove then table.insert(m,s)end end end n=d(n)table.sort(k,e)table.sort(l,e)table.sort(m,e)table.sort(o,e)table.sort(p,e)table.sort(q,e)return setmetatable({_world=i,_onExit=k,_onEnter=l,_onRemove=m,_task=n,_render=o,_process=p,_transform=q,_schedulers={},},f)end function f:ExecOnExitEnter(i,j)local k=true local l={}for m,n in pairs(j)do local o=l[n]if not o then o={}l[n]=o end local p=m.archetype local q=o[p]if not q then q={}o[p]=q end table.insert(q,m)k=false end if k then return end self:_ExecOnEnter(i,l)self:_ExecOnExit(i,l)end function f:_ExecOnEnter(i,j)local k=self._world for l,m in ipairs(self._onEnter)do local n=m.Query for o,p in pairs(j)do if not n:Match(o)then for q,r in pairs(p)do if n:Match(q)then for s,t in ipairs(r)do k.version=k.version+1 m:OnEnter(i,t)m.version=k.version end end end end end end end function f:_ExecOnExit(i,j)local k=self._world for l,m in ipairs(self._onExit)do local n=m.Query for o,p in pairs(j)do if n:Match(o)then for q,r in pairs(p)do if not n:Match(q)then for s,t in ipairs(r)do k.version=k.version+1 m:OnExit(i,t)m.version=k.version end end end end end end end function f:ExecOnRemove(i,j)local k=true local l={}for n,o in pairs(j)do local p=l[o]if not p then p={}l[o]=p end table.insert(p,n)k=false end if k then return end local m=self._world for n,o in ipairs(self._onRemove)do for p,q in pairs(l)do if o.Query:Match(p)then for r,s in ipairs(q)do m.version=m.version+1 o:OnRemove(i,s)o.version=m.version end end end end end local function g(i,j,k)for l,m in ipairs(j)do if(m.ShouldUpdate==nil or m.ShouldUpdate(k))then i.version=i.version+1 m:Update(k)m.version=i.version end end end function f:ExecProcess(i)g(self._world,self._process,i)end function f:ExecTransform(i)g(self._world,self._transform,i)end function f:ExecRender(i)g(self._world,self._render,i)end function f:ExecTasks(i)while i>0 do local j=false local k,l=0,#self._schedulers-1 while k<=l do k=k+1 local m=self._schedulers[k]local n,o=m.Resume(i)if o then j=true end i=i-(n+0.00001)if(i<=0)then break end end if not j then return end end end local function h(i,j,k,l)local m=i.System m._TaskState="running"if(m.ShouldUpdate==nil or m.ShouldUpdate(j))then k.version=k.version+1 m:Update(j)m.version=k.version end m._TaskState="suspended"l(i)end function f:ScheduleTasks(i)local j=self._world local k={}local l={}local m={}local n={}local o={}local p,q=0,#self._task-1 while p<=q do p=p+1 local s=self._task[p]if(s.System._TaskState=="suspended")then s.System._TaskState="scheduled"local t=false for u,v in pairs(s.Depends)do t=true if o[u]==nil then o[u]={}end table.insert(o[u],s)end if(not t)then table.insert(k,s)end m[s]=true end end local function r(s)s.Thread=nil s.LastExecTime=nil n[s]=true if o[s]then local t=o[s]local u,v=0,#t-1 while u<=v do u=u+1 local w=t[u]if m[w]then local x=true for y,z in pairs(w.Depends)do if n[y]~=true then x=false break end end if x then m[w]=nil w.LastExecTime=0 w.Thread=coroutine.create(h)table.insert(l,w)end end end end end if#k>0 then local s,t=0,#k-1 while s<=t do s=s+1 local v=k[s]m[v]=nil v.LastExecTime=0 v.Thread=coroutine.create(h)table.insert(l,v)end local u u={Resume=function(v)table.sort(l,function(A,B)return A.LastExecTime<B.LastExecTime end)local w=0 local x,y=0,#l-1 while x<=y do x=x+1 local A=l[x]if A.Thread~=nil then local B=os.clock()A.LastExecTime=B coroutine.resume(A.Thread,A,i,j,r)w=w+(os.clock()-B)if(w>v)then break end end end for A,B in ipairs(l)do if B.Thread==nil then local C=table.find(l,B)if C~=nil then table.remove(l,C)end end end local z=#l>0 if(not z)then local A=table.find(self._schedulers,u)if A~=nil then table.remove(self._schedulers,A)end end return w,z end}table.insert(self._schedulers,u)end end return f end b["Timer"]=function()local d=4 local e={}e.__index=e local f={}f.__index=f function f.New(g)local h=setmetatable({Time=setmetatable({Now=0,NowReal=0,Frame=0,FrameReal=0,Process=0,Delta=0,DeltaFixed=0,Interpolation=0},e),Frequency=0,LastFrame=0,ProcessOld=0,FirstUpdate=0,},f)h:SetFrequency(g)return h end function f:SetFrequency(g)if g==nil then g=30 end local h=math.floor(math.abs(g)/2)*2 if h<2 then h=2 end if g~=h then g=h print(string.format(">>> ATTENTION! The execution frequency of world has been changed to %d <<<",h))end self.Frequency=g self.Time.DeltaFixed=1000/g/1000 end function f:Update(g,h,i)if(self.FirstUpdate==0)then self.FirstUpdate=g end local j=g g=g-self.FirstUpdate local k=self.Time k.Now=g k.NowReal=j if h=='process'then local l=k.Process k.Frame=g k.FrameReal=j if self.LastFrame==0 then self.LastFrame=k.Frame end if k.Process==0 then k.Process=k.Frame self.ProcessOld=k.Frame end k.Delta=k.Frame-self.LastFrame k.Interpolation=1 local m=0 local n=false while(k.Process<=k.Frame and m<d)do n=true i(k)m=m+1 k.Process=k.Process+k.DeltaFixed end if n then self.ProcessOld=l end else if k.Process~=self.ProcessOld then k.Interpolation=1+(g-k.Process)/k.Delta else k.Interpolation=1 end i(k)if h=='render'then self.LastFrame=k.Frame end end end return f end b["Utility"]=function()local d={}if table.unpack==nil then table.unpack=unpack end if table.find==nil then table.find=function(g,h,i)local j=#g for k=i or 1,j,1 do if g[k]==h then return k end end return nil end end local function e(g)local h={}for i,j in pairs(g)do if type(j)=="table"then j=e(j)end h[i]=j end return h end d.copyDeep=e local function f(g,h)for i,j in pairs(h)do if(type(j)=="table")then local k=g[i]if(k==nil or type(k)~="table")then g[i]=e(j)else g[i]=f(k,j)end else g[i]=j end end return g end d.mergeDeep=f return d end b["World"]=function()local d=c("Timer")local e=c("Event")local f=c("Entity")local g=c("Archetype")local h=c("SystemExecutor")local i=c("EntityRepository")local j={}j.__index=j function j.New(k,l,m)local n=setmetatable({version=0,maxScheduleExecTimePercent=0.7,_dirty=false,_timer=d.New(l),_systems={},_repository=i.New(),_entitiesCreated={},_entitiesRemoved={},_entitiesUpdated={},_onChangeArchetypeEvent=e.New(),},j)n._executor=h.New(n,{})n._onChangeArchetypeEvent:Connect(function(o,p,q)n:_OnChangeArchetype(o,p,q)end)if(k~=nil)then for o,p in ipairs(k)do n:AddSystem(p)end end if(not m and j.LoopManager)then n._loopCancel=j.LoopManager.Register(n)end return n end function j:SetFrequency(k)k=self._timer:SetFrequency(k)end function j:GetFrequency(k)return self._timer.Frequency end function j:AddSystem(k,l)if k then if l==nil then l={}end if self._systems[k]==nil then self._systems[k]=k.New(self,l)self._executor=h.New(self,self._systems)end end end function j:Entity(...)local k=f.New(self._onChangeArchetypeEvent,{...})self._dirty=true self._entitiesCreated[k]=true k.version=self.version k.isAlive=false return k end function j:Remove(k)if self._entitiesRemoved[k]==true then return end if self._entitiesCreated[k]==true then self._entitiesCreated[k]=nil else self._repository:Remove(k)self._entitiesRemoved[k]=true if self._entitiesUpdated[k]==nil then self._entitiesUpdated[k]=k.archetype end end self._dirty=true k.isAlive=false end function j:Exec(k)if(k.isQueryBuilder)then k=k.Build()end return self._repository:Query(k)end function j:Update(k,l)self._timer:Update(l,k,function(m)if k=='process'then self._executor:ScheduleTasks(m)self._executor:ExecProcess(m)elseif k=='transform'then self._executor:ExecTransform(m)else self._executor:ExecRender(m)end local n=(m.DeltaFixed*(self.maxScheduleExecTimePercent or 0.7))/3 self._executor:ExecTasks(n)while self._dirty do self._dirty=false local o={}for r,s in pairs(self._entitiesRemoved)do o[r]=self._entitiesUpdated[r]self._entitiesUpdated[r]=nil end self._entitiesRemoved={}self._executor:ExecOnRemove(m,o)o=nil local p={}local q=false for r,s in pairs(self._entitiesUpdated)do if(s~=r.archetype)then q=true p[r]=s end end self._entitiesUpdated={}for r,s in pairs(self._entitiesCreated)do q=true p[r]=g.EMPTY r.isAlive=true self._repository:Insert(r)end self._entitiesCreated={}if q then self._executor:ExecOnExitEnter(m,p)p=nil end end end)end function j:Destroy()if self._loopCancel then self._loopCancel()self._loopCancel=nil end if self._onChangeArchetypeEvent then self._onChangeArchetypeEvent:Destroy()self._onChangeArchetypeEvent=nil end self._repository=nil if self._systems then for k,l in pairs(self._systems)do l:Destroy()end self._systems=nil end self._timer=nil self._ExecPlan=nil self._entitiesCreated=nil self._entitiesUpdated=nil self._entitiesRemoved=nil setmetatable(self,nil)end function j:_OnChangeArchetype(k,l,m)if k.isAlive then if self._entitiesUpdated[k]==nil then self._dirty=true self._entitiesUpdated[k]=l end self._repository:Update(k)k.version=self.version end end return j end return c("ECS")