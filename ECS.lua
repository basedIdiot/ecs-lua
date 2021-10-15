--[[
	ECS Lua v2.1.0 [2021-10-15 11:00]

	ECS Lua is a fast and easy to use ECS (Entity Component System) engine for game development.

	This is a minified version of ECS Lua, to see the full source code visit
	https://github.com/nidorx/ecs-lua

   Discussions about this script are at https://devforum.roblox.com/t/841175

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
local a,b={},{}local function c(d)if(not a[d])then a[d]={r=b[d]()}end return a[d].r end b["Archetype"]=function()local d={}local e={}local f={}local g=0 local h={}h.__index=h function h.Of(i)local j={}local k={}for m,n in ipairs(i)do if(n.IsCType and not n.isComponent)then if n.IsQualifier then if k[n]==nil then k[n]=true table.insert(j,n.Id)end n=n.SuperClass end if k[n]==nil then k[n]=true table.insert(j,n.Id)end end end table.sort(j)local l="_"..table.concat(j,"_")if d[l]==nil then d[l]=setmetatable({id=l,_components=k},h)g=g+1 end return d[l]end function h.Version()return g end function h:Has(i)return(self._components[i]==true)end function h:With(i)if self._components[i]==true then return self end local j=e[self]if not j then j={}e[self]=j end local k=j[i]if k==nil then local l={i}for m,n in pairs(self._components)do table.insert(l,m)end k=h.Of(l)j[i]=k end return k end function h:WithAll(i)local j={}for k,l in pairs(self._components)do table.insert(j,k)end for k,l in ipairs(i)do if self._components[l]==nil then table.insert(j,l)end end return h.Of(j)end function h:Without(i)if self._components[i]==nil then return self end local j=f[self]if not j then j={}f[self]=j end local k=j[i]if k==nil then local l={}for m,n in pairs(self._components)do if m~=i then table.insert(l,m)end end k=h.Of(l)j[i]=k end return k end function h:WithoutAll(i)local j={}for l,m in ipairs(i)do j[m]=true end local k={}for l,m in pairs(self._components)do if j[l]==nil then table.insert(k,l)end end return h.Of(k)end h.EMPTY=h.Of({})return h end b["Component"]=function()local d=c("Utility")local e=c("ComponentFSM")local f=d.copyDeep local g=d.mergeDeep local h=0 local function i(l,m)h=h+1 local n={Id=h,IsCType=true,SuperClass=m}n.__index=n if m==nil then m=n m._Qualifiers={["Primary"]=n}m._QualifiersArr={n}m._Initializers={}else m.HasQualifier=true n.IsQualifier=true n.HasQualifier=true end local o=m._Qualifiers local p=m._QualifiersArr setmetatable(n,{__call=function(q,r)return n.New(r)end,__index=function(q,r)if(r=="States")then return m.__States end if(r=="Case"or r=="StateInitial")then return rawget(m,r)end end,__newindex=function(q,r,s)if(r=="Case"or r=="States"or r=="StateInitial")then if n==m then if(r=="States")then if not m.IsFSM then e.AddCapability(m,s)for t,u in pairs(o)do if u~=m then e.AddMethods(m,u)end end end else rawset(q,r,s)end end else rawset(q,r,s)end end})if m.IsFSM then e.AddMethods(m,n)end function n.Qualifier(q)if type(q)~="string"then for s,t in ipairs(p)do if t==q then return q end end return nil end local r=o[q]if r==nil then r=i(l,m)o[q]=r table.insert(p,r)end return r end function n.Qualifiers(...)local q={...}if#q==0 then return p else local r={}local s={}for t,u in ipairs({...})do local v=n.Qualifier(u)if v and s[v]==nil then s[v]=true table.insert(r,v)end end return r end end function n.New(q)if(q~=nil and type(q)~="table")then q={value=q}end local r=setmetatable(l(q)or{},n)for s,t in ipairs(m._Initializers)do t(r)end r.isComponent=true r._qualifiers={[n]=r}return r end function n:GetType()return n end function n:Is(q)return q==n or q==m end function n:Primary()return self._qualifiers[m]end function n:Qualified(q)return self._qualifiers[n.Qualifier(q)]end function n:QualifiedAll()local q={}for r,s in pairs(o)do q[r]=self._qualifiers[s]end return q end function n:Merge(q)if m.HasQualifier then if self==q then return end if self._qualifiers==q._qualifiers then return end if not q:Is(m)then return end local r=n local s=q:GetType()local t if r==m then t=self._qualifiers elseif s==m then t=q._qualifiers elseif self._qualifiers[m]~=nil then t=self._qualifiers[m]._qualifiers elseif q._qualifiers[m]~=nil then t=q._qualifiers[m]._qualifiers end if t~=nil then if self._qualifiers~=t then for u,v in pairs(self._qualifiers)do if m~=u then t[u]=v v._qualifiers=t end end end if q._qualifiers~=t then for u,v in pairs(q._qualifiers)do if m~=u then t[u]=v v._qualifiers=t end end end else for u,v in pairs(q._qualifiers)do if r~=u then self._qualifiers[u]=v v._qualifiers=self._qualifiers end end end end end function n:Detach()if not m.HasQualifier then return end self._qualifiers[n]=nil self._qualifiers={[n]=self}end return n end local function j(l)return l or{}end local k={}function k.Create(l)local m=j if l~=nil then local n=type(l)if(n=="function")then m=l else if(n~="table")then l={value=l}end m=function(o)local p=f(l)if(o~=nil)then g(p,o)end return p end end end return i(m,nil)end return k end b["ComponentFSM"]=function()local d=c("Query")local e=d.Filter(function(g,h)local i=h.States local j=h.IsSuperClass local k=h.ComponentClass if j then local l=k.Qualifiers()for m,n in ipairs(l)do local o=g[n]if(o~=nil and i[o:GetState()]==true)then return true end end return false else local l=g[k]if l==nil then return false end return i[l:GetState()]==true end end)local f={}function f.AddCapability(g,h)g.IsFSM=true local i=setmetatable({},{__newindex=function(j,k,l)if(type(l)~="table")then l={l}end if table.find(l,"*")then rawset(j,k,"*")else local m=table.find(l,k)if m~=nil then table.remove(l,m)if#l==0 then l="*"end end rawset(j,k,l)end end})rawset(g,"__States",i)for j,k in pairs(h)do if g.StateInitial==nil then g.StateInitial=j end i[j]=k end f.AddMethods(g,g)table.insert(g._Initializers,function(j)j:SetState(g.StateInitial)end)end function f.AddMethods(g,h)h.IsFSM=true local i=g.States function h.In(...)local j={}local k=0 for l,m in ipairs({...})do if(i[m]~=nil and j[m]==nil)then k=k+1 j[m]=true end end if k==0 then return{}end return e({States=j,IsSuperClass=(h==g),ComponentClass=h,})end function h:SetState(j)if(j==nil or i[j]==nil)then return end local k=self:GetState()if(k==j)then return end if(k~=nil)then local m=i[k]if(m~="*"and table.find(m,j)==nil)then return end end self._state=j self._statePrev=k self._stateTime=os.clock()local l=g.Case and g.Case[j]if l then l(self,k)end end function h:GetState()return self._state or g.StateInitial end function h:GetPrevState()return self._statePrev or nil end function h:GetStateTime()return self._stateTime or 0 end end return f end b["ECS"]=function()local d=c("Query")local e=c("World")local f=c("System")local g=c("Archetype")local h=c("Component")local function i(k)e.LoopManager=k end pcall(function()if(game and game.ClassName=="DataModel")then i(c("RobloxLoopManager")())end end)local j={Query=d,World=e.New,System=f.Create,Archetype=g,Component=h.Create,SetLoopManager=i}if _G.ECS==nil then _G.ECS=j else local k=_G.warn or print k("ECS Lua was not registered in the global variables, there is already another object registered.")end return j end b["Entity"]=function()local d=c("Archetype")local e=0 local function f(l,...)local m={...}local n=l._data if(#m==1)then local p=m[1]if(p.IsCType and not p.isComponent)then return n[p]else return nil end end local o={}for p,q in ipairs(m)do if(q.IsCType and not q.isComponent)then table.insert(o,n[q])end end return table.unpack(o)end local function g(l,m,n)local o=l._data local p for q,r in ipairs(n.Qualifiers())do if r~=n then p=o[r]if p then break end end end if p then p:Merge(m)end end local function h(l,...)local m={...}local n=l._data local o=l.archetype local p=o local q={}local r=m[1]if(r and r.IsCType and not r.isComponent)then local s=m[2]local t if s==nil then local u=n[r]if u then u:Detach()end n[r]=nil p=p:Without(r)elseif s.isComponent then local u=n[r]if(u~=s)then if u then u:Detach()end r=s:GetType()n[r]=s p=p:With(r)if(r.HasQualifier or r.IsQualifier)then g(l,s,r)end end else local u=n[r]if u then u:Detach()end local v=r(s)n[r]=v p=p:With(r)if(r.HasQualifier or r.IsQualifier)then g(l,v,r)end end else for s,t in ipairs(m)do if(t.isComponent)then local u=t:GetType()local v=n[u]if(v~=t)then if v then v:Detach()end n[u]=t p=p:With(u)if(u.HasQualifier or u.IsQualifier)then g(l,t,u)end end end end end if(o~=p)then l.archetype=p l._onChange:Fire(l,o)end end local function i(l,...)local m=l._data local n=l.archetype local o=n for p,q in ipairs({...})do if q.isComponent then local r=q:GetType()local s=m[r]if s then s:Detach()end m[r]=nil o=o:Without(r)elseif q.IsCType then local r=m[q]if r then r:Detach()end m[q]=nil o=o:Without(q)end end if l.archetype~=o then l.archetype=o l._onChange:Fire(l,n)end end local function j(l,m)local n=l._data local o={}if(m~=nil and m.IsCType and not m.isComponent)then local p=m.Qualifiers()for q,r in ipairs(p)do local s=n[r]if s then table.insert(o,s)end end else for p,q in pairs(n)do table.insert(o,q)end end return o end local k={__index=function(l,m)if(type(m)=="table")then return f(l,m)end end,__newindex=function(l,m,n)local o=true if(type(m)=="table"and(m.IsCType and not m.isComponent))then h(l,m,n)else rawset(l,m,n)end end}function k.New(l,m)local n=d.EMPTY local o={}if(m~=nil and#m>0)then local p={}for q,r in ipairs(m)do local s=r:GetType()table.insert(p,s)o[s]=r end n=d.Of(p)end e=e+1 return setmetatable({_data=o,_onChange=l,id=e,isAlive=false,archetype=n,Get=f,Set=h,Unset=i,GetAll=j,},k)end return k end b["EntityRepository"]=function()local d=c("Event")local e={}e.__index=e function e.New()return setmetatable({_archetypes={},_entitiesArchetype={},},e)end function e:Insert(f)if(self._entitiesArchetype[f]==nil)then local g=f.archetype local h=self._archetypes[g]if(h==nil)then h={Count=0,Entities={}}self._archetypes[g]=h end h.Entities[f]=true h.Count=h.Count+1 self._entitiesArchetype[f]=g else self:Update(f)end end function e:Remove(f)local g=self._entitiesArchetype[f]if g==nil then return end self._entitiesArchetype[f]=nil local h=self._archetypes[g]if(h~=nil and h.Entities[f]==true)then h.Entities[f]=nil h.Count=h.Count-1 if(h.Count==0)then self._archetypes[g]=nil end end end function e:Update(f)local g=self._entitiesArchetype[f]if(g==nil or g==f.archetype)then return end self:Remove(f)self:Insert(f)end function e:Query(f)local g={}for h,i in pairs(self._archetypes)do if f:Match(h)then table.insert(g,i.Entities)end end return f:Result(g),#g>0 end function e:FastCheck(f)for g,h in pairs(self._archetypes)do if f:Match(g)then return true end end return false end return e end b["Event"]=function()local d={}d.__index=d function d.New(f,g)return setmetatable({_Event=f,_Handler=g},d)end function d:Disconnect()local f=self._Event if(f and not f.destroyed)then local g=table.find(f._handlers,self._Handler)if g~=nil then table.remove(f._handlers,g)end end setmetatable(self,nil)end local e={}e.__index=e function e.New()return setmetatable({_handlers={}},e)end function e:Connect(f)if(type(f)=="function")then table.insert(self._handlers,f)return d.New(self,f)end error(("Event:Connect(%s)"):format(typeof(f)),2)end function e:Fire(...)if not self.destroyed then for f,g in ipairs(self._handlers)do g(table.unpack({...}))end end end function e:Destroy()setmetatable(self,nil)self._handlers=nil self.destroyed=true end return e end b["Query"]=function()local d=c("QueryResult")local e={}local f={}f.__index=f setmetatable(f,{__call=function(i,j,k,l)return f.New(j,k,l)end,})local function g(i,j,k)local l={}local m={}local n={}for o,p in ipairs(i)do if(l[p]==nil)then if(p.IsCType and not p.isComponent)then l[p]=true table.insert(m,p)table.insert(n,p.Id)else if p.Filter then l[p]=true p[j]=true table.insert(k,p)end end end end if#m>0 then table.sort(n)local o="_"..table.concat(n,"_")return m,o end end function f.New(i,j,k)local l={}local m,n,o if(j~=nil)then j,m=g(j,"IsAnyFilter",l)end if(i~=nil)then i,n=g(i,"IsAllFilter",l)end if(k~=nil)then k,o=g(k,"IsNoneFilter",l)end return setmetatable({isQuery=true,_any=j,_all=i,_none=k,_anyKey=m,_allKey=n,_noneKey=o,_cache={},_clauses=#l>0 and l or nil},f)end function f:Result(i)self._lastResultChunks=i return d.New(i,self._clauses)end function f:Match(i)local j=self._cache local k=j[i]if k~=nil then return k else local l=e[i]if(l==nil)then l={Any={},All={},None={}}e[i]=l end local m=self._noneKey if m then local p=l.None[m]if(p==nil)then p=true for q,r in ipairs(self._none)do if i:Has(r)then p=false break end end l.None[m]=p end if(p==false)then j[i]=false return false end end local n=self._anyKey if n then local p=l.Any[n]if(p==nil)then p=false if(l.All[n]==true)then p=true else for q,r in ipairs(self._any)do if i:Has(r)then p=true break end end end l.Any[n]=p end if(p==false)then j[i]=false return false end end local o=self._allKey if o then local p=l.All[o]if(p==nil)then local q=true for r,s in ipairs(self._all)do if(not i:Has(s))then q=false break end end if q then p=true else p=false end l.All[o]=p end j[i]=p return p end j[i]=true return true end end local function h()local i={isQueryBuilder=true}local j function i.All(...)j=nil i._all={...}return i end function i.Any(...)j=nil i._any={...}return i end function i.None(...)j=nil i._none={...}return i end function i.Build()if j==nil then j=f.New(i._all,i._any,i._none)end return j end return i end function f.All(...)return h().All(...)end function f.Any(...)return h().Any(...)end function f.None(...)return h().None(...)end function f.Filter(i)return function(j)return{Filter=i,Config=j}end end return f end b["QueryResult"]=function()local function d(l,m,n)return m,(l(m)==true),true end local function e(l,m,n)return l(m),true,true end local function f(l,m,n)local o=(n<=l)return m,o,o end local function g(l,m,n)local o=true for p,q in ipairs(l)do if(q.Filter(m,q.Config)==true)then o=false break end end return m,o,true end local function h(l,m,n)local o=true for p,q in ipairs(l)do if(q.Filter(m,q.Config)==false)then o=false break end end return m,o,true end local function i(l,m,n)local o=false for p,q in ipairs(l)do if(q.Filter(m,q.Config)==true)then o=true break end end return m,o,true end local j={}local k={}k.__index=k function k.New(l,m)local n=j if(m and#m>0)then local o={}local p={}local q={}n={}for r,s in ipairs(m)do if s.IsNoneFilter then table.insert(q,s)elseif s.IsAnyFilter then table.insert(p,s)else table.insert(o,s)end end if(#q>0)then table.insert(n,{g,q})end if(#o>0)then table.insert(n,{h,o})end if(#p>0)then table.insert(n,{i,p})end end return setmetatable({chunks=l,_pipeline=n,},k)end function k:With(l,m)local n={}for o,p in ipairs(self._pipeline)do table.insert(n,p)end table.insert(n,{l,m})return setmetatable({chunks=self.chunks,_pipeline=n,},k)end function k:Filter(l)return self:With(d,l)end function k:Map(l)return self:With(e,l)end function k:Limit(l)return self:With(f,l)end function k:AnyMatch(l)local m=false self:Run(function(n)if l(n)then m=true end return m end)return m end function k:AllMatch(l)local m=true self:Run(function(n)if(not l(n))then m=false end return m==false end)return m end function k:FindAny()local l self:Run(function(m)l=m return true end)return l end function k:ForEach(l)self:Run(function(m,n)return l(m,n)==true end)end function k:ToArray()local l={}self:Run(function(m)table.insert(l,m)end)return l end function k:Iterator()local l=coroutine.create(function()self:Run(function(m,n)coroutine.yield(m,n)end)end)return function()local m,n,o=coroutine.resume(l)return o,n end end function k:Run(l)local m=1 local n=self._pipeline local o=#n>0 if(not o)then for p,q in ipairs(self.chunks)do for r,s in pairs(q)do if(l(r,m)==true)then return end m=m+1 end end else for p,q in ipairs(self.chunks)do for r,s in pairs(q)do local t=false local u=true local v=r if(u and o)then for w,x in ipairs(n)do local y,z,A=x[1](x[2],v,m)if(not A)then t=true end if z then v=y else u=false break end end end if u then if(l(v,m)==true)then return end m=m+1 end if t then return end end end end end return k end b["RobloxLoopManager"]=function()local function d()local e=game:GetService("RunService")return{Register=function(f)local g=e.Stepped:Connect(function()f:Update("process",os.clock())end)local h=e.Heartbeat:Connect(function()f:Update("transform",os.clock())end)local i if(not e:IsServer())then i=e.RenderStepped:Connect(function()f:Update("render",os.clock())end)end return function()g:Disconnect()h:Disconnect()if i then i:Disconnect()end end end}end return d end b["System"]=function()local d={"task","render","process","transform"}local e={}function e.Create(f,g,h,i)if(f==nil or not table.find(d,f))then error("The step parameter must one of ",table.concat(d,", "))end if type(g)=="function"then i=g g=nil end if(g==nil or g<0)then g=50 end if type(h)=="function"then i=h h=nil end if(h and h.isQueryBuilder)then h=h.Build()end local j={Step=f,Order=g,Query=h,}j.__index=j function j.New(k,l)local m=setmetatable({version=0,_world=k,_config=l,},j)if m.Initialize then m:Initialize(l)end return m end function j:GetType()return j end function j:Result(k)return self._world:Exec(k or j.Query)end function j:Destroy()if self.OnDestroy then self.OnDestroy()end setmetatable(self,nil)for k,l in pairs(self)do self[k]=nil end end if i and type(i)=="function"then j.Update=i end return j end return e end b["SystemExecutor"]=function()local function d(i)local j={}local k={}for l,m in ipairs(i)do local n=m:GetType()if(m._TaskState==nil)then m._TaskState="suspended"end if not k[n]then local o={Type=n,System=m,Depends={}}k[n]=o table.insert(j,o)end end for l,m in ipairs(j)do local n=m.Type.Before if(n~=nil and#n>0)then for p,q in ipairs(n)do local r=k[q]if r then r.Depends[m]=true end end end local o=m.Type.After if(o~=nil and#o>0)then for p,q in ipairs(o)do local r=k[q]if r then m.Depends[r]=true end end end end return j end local function e(i,j)return i.Order<j.Order end local f={}f.__index=f function f.New(i,j)local k={}local l={}local m={}local n={}local o={}local p={}local q={}for s,t in pairs(j)do local u=t.Step if t.Update then if u=="task"then table.insert(n,t)elseif u=="process"then table.insert(p,t)elseif u=="transform"then table.insert(q,t)elseif u=="render"then table.insert(o,t)end end if(t.Query and t.Query.isQuery and u~="task")then if t.OnExit then table.insert(k,t)end if t.OnEnter then table.insert(l,t)end if t.OnRemove then table.insert(m,t)end end end n=d(n)table.sort(k,e)table.sort(l,e)table.sort(m,e)table.sort(o,e)table.sort(p,e)table.sort(q,e)local r=setmetatable({_world=i,_onExit=k,_onEnter=l,_onRemove=m,_task=n,_render=o,_process=p,_transform=q,_schedulers={},_lastFrameMatchQueries={},_currentFrameMatchQueries={},},f)i:OnQueryMatch(function(s)r._currentFrameMatchQueries[s]=true end)return r end function f:ExecOnExitEnter(i,j)local k=true local l={}for m,n in pairs(j)do local o=l[n]if not o then o={}l[n]=o end local p=m.archetype local q=o[p]if not q then q={}o[p]=q end table.insert(q,m)k=false end if k then return end self:_ExecOnEnter(i,l)self:_ExecOnExit(i,l)end function f:_ExecOnEnter(i,j)local k=self._world for l,m in ipairs(self._onEnter)do local n=m.Query for o,p in pairs(j)do if not n:Match(o)then for q,r in pairs(p)do if n:Match(q)then for s,t in ipairs(r)do k.version=k.version+1 m:OnEnter(i,t)m.version=k.version end end end end end end end function f:_ExecOnExit(i,j)local k=self._world for l,m in ipairs(self._onExit)do local n=m.Query for o,p in pairs(j)do if n:Match(o)then for q,r in pairs(p)do if not n:Match(q)then for s,t in ipairs(r)do k.version=k.version+1 m:OnExit(i,t)m.version=k.version end end end end end end end function f:ExecOnRemove(i,j)local k=true local l={}for n,o in pairs(j)do local p=l[o]if not p then p={}l[o]=p end table.insert(p,n)k=false end if k then return end local m=self._world for n,o in ipairs(self._onRemove)do for p,q in pairs(l)do if o.Query:Match(p)then for r,s in ipairs(q)do m.version=m.version+1 o:OnRemove(i,s)o.version=m.version end end end end end local function g(i,j,k)local l=i._world local m=i._lastFrameMatchQueries local n=i._currentFrameMatchQueries for o,p in ipairs(j)do local q=true if p.Query then local r=p.Query if m[r]==true or n[r]==true then q=true else q=l:FastCheck(r)n[r]=q end end if q then if(p.ShouldUpdate==nil or p.ShouldUpdate(k))then l.version=l.version+1 p:Update(k)p.version=l.version end end end end function f:ExecProcess(i)self._currentFrameMatchQueries={}g(self,self._process,i)end function f:ExecTransform(i)g(self,self._transform,i)end function f:ExecRender(i)g(self,self._render,i)self._lastFrameMatchQueries=self._currentFrameMatchQueries end function f:ExecTasks(i)while i>0 do local j=false local k,l=0,#self._schedulers-1 while k<=l do k=k+1 local m=self._schedulers[k]local n,o=m.Resume(i)if o then j=true end i=i-(n+0.00001)if(i<=0)then break end end if not j then return end end end local function h(i,j,k,l)local m=i.System m._TaskState="running"if(m.ShouldUpdate==nil or m.ShouldUpdate(j))then k.version=k.version+1 m:Update(j)m.version=k.version end m._TaskState="suspended"l(i)end function f:ScheduleTasks(i)local j=self._world local k={}local l={}local m={}local n={}local o={}local p,q=0,#self._task-1 while p<=q do p=p+1 local s=self._task[p]if(s.System._TaskState=="suspended")then s.System._TaskState="scheduled"local t=false for u,v in pairs(s.Depends)do t=true if o[u]==nil then o[u]={}end table.insert(o[u],s)end if(not t)then table.insert(k,s)end m[s]=true end end local function r(s)s.Thread=nil s.LastExecTime=nil n[s]=true if o[s]then local t=o[s]local u,v=0,#t-1 while u<=v do u=u+1 local w=t[u]if m[w]then local x=true for y,z in pairs(w.Depends)do if n[y]~=true then x=false break end end if x then m[w]=nil w.LastExecTime=0 w.Thread=coroutine.create(h)table.insert(l,w)end end end end end if#k>0 then local s,t=0,#k-1 while s<=t do s=s+1 local v=k[s]m[v]=nil v.LastExecTime=0 v.Thread=coroutine.create(h)table.insert(l,v)end local u u={Resume=function(v)table.sort(l,function(A,B)return A.LastExecTime<B.LastExecTime end)local w=0 local x,y=0,#l-1 while x<=y do x=x+1 local A=l[x]if A.Thread~=nil then local B=os.clock()A.LastExecTime=B coroutine.resume(A.Thread,A,i,j,r)w=w+(os.clock()-B)if(w>v)then break end end end for A,B in ipairs(l)do if B.Thread==nil then local C=table.find(l,B)if C~=nil then table.remove(l,C)end end end local z=#l>0 if(not z)then local A=table.find(self._schedulers,u)if A~=nil then table.remove(self._schedulers,A)end end return w,z end}table.insert(self._schedulers,u)end end return f end b["Timer"]=function()local d=4 local e={}e.__index=e local f={}f.__index=f function f.New(g)local h=setmetatable({Time=setmetatable({Now=0,NowReal=0,Frame=0,FrameReal=0,Process=0,Delta=0,DeltaFixed=0,Interpolation=0},e),Frequency=0,LastFrame=0,ProcessOld=0,FirstUpdate=0,},f)h:SetFrequency(g)return h end function f:SetFrequency(g)if g==nil then g=30 end local h=math.floor(math.abs(g)/2)*2 if h<2 then h=2 end if g~=h then g=h end self.Frequency=g self.Time.DeltaFixed=1000/g/1000 end function f:Update(g,h,i)if(self.FirstUpdate==0)then self.FirstUpdate=g end local j=g g=g-self.FirstUpdate local k=self.Time k.Now=g k.NowReal=j if h=="process"then local l=k.Process k.Frame=g k.FrameReal=j if self.LastFrame==0 then self.LastFrame=k.Frame end if k.Process==0 then k.Process=k.Frame self.ProcessOld=k.Frame end k.Delta=k.Frame-self.LastFrame k.Interpolation=1 local m=0 local n=false while(k.Process<=k.Frame and m<d)do n=true i(k)m=m+1 k.Process=k.Process+k.DeltaFixed end if n then self.ProcessOld=l end else if k.Process~=self.ProcessOld then k.Interpolation=1+(g-k.Process)/k.Delta else k.Interpolation=1 end i(k)if h=="render"then self.LastFrame=k.Frame end end end return f end b["Utility"]=function()local d={}if table.unpack==nil then table.unpack=unpack end if table.find==nil then table.find=function(g,h,i)local j=#g for k=i or 1,j,1 do if g[k]==h then return k end end return nil end end local function e(g)local h={}for i,j in pairs(g)do if type(j)=="table"then j=e(j)end h[i]=j end return h end d.copyDeep=e local function f(g,h)for i,j in pairs(h)do if(type(j)=="table")then local k=g[i]if(k==nil or type(k)~="table")then g[i]=e(j)else g[i]=f(k,j)end else g[i]=j end end return g end d.mergeDeep=f return d end b["World"]=function()local d=c("Timer")local e=c("Event")local f=c("Entity")local g=c("Archetype")local h=c("SystemExecutor")local i=c("EntityRepository")local j={}j.__index=j function j.New(k,l,m)local n=setmetatable({version=0,maxScheduleExecTimePercent=0.7,_dirty=false,_timer=d.New(l),_systems={},_repository=i.New(),_entitiesCreated={},_entitiesRemoved={},_entitiesUpdated={},_onQueryMatch=e.New(),_onChangeArchetypeEvent=e.New(),},j)n._executor=h.New(n,{})n._onChangeArchetypeEvent:Connect(function(o,p,q)n:_OnChangeArchetype(o,p,q)end)if(k~=nil)then for o,p in ipairs(k)do n:AddSystem(p)end end if(not m and j.LoopManager)then n._loopCancel=j.LoopManager.Register(n)end return n end function j:SetFrequency(k)k=self._timer:SetFrequency(k)end function j:GetFrequency(k)return self._timer.Frequency end function j:AddSystem(k,l)if k then if l==nil then l={}end if self._systems[k]==nil then self._systems[k]=k.New(self,l)self._executor=h.New(self,self._systems)end end end function j:Entity(...)local k=f.New(self._onChangeArchetypeEvent,{...})self._dirty=true self._entitiesCreated[k]=true k.version=self.version k.isAlive=false return k end function j:Remove(k)if self._entitiesRemoved[k]==true then return end if self._entitiesCreated[k]==true then self._entitiesCreated[k]=nil else self._repository:Remove(k)self._entitiesRemoved[k]=true if self._entitiesUpdated[k]==nil then self._entitiesUpdated[k]=k.archetype end end self._dirty=true k.isAlive=false end function j:Exec(k)if(k.isQueryBuilder)then k=k.Build()end local l,m=self._repository:Query(k)if m then self._onQueryMatch:Fire(k)end return l end function j:FastCheck(k)if(k.isQueryBuilder)then k=k.Build()end return self._repository:FastCheck(k)end function j:OnQueryMatch(k)return self._onQueryMatch:Connect(k)end function j:Update(k,l)self._timer:Update(l,k,function(m)if k=="process"then self._executor:ScheduleTasks(m)self._executor:ExecProcess(m)elseif k=="transform"then self._executor:ExecTransform(m)else self._executor:ExecRender(m)end local n=(m.DeltaFixed*(self.maxScheduleExecTimePercent or 0.7))/3 self._executor:ExecTasks(n)while self._dirty do self._dirty=false local o={}for r,s in pairs(self._entitiesRemoved)do o[r]=self._entitiesUpdated[r]self._entitiesUpdated[r]=nil end self._entitiesRemoved={}self._executor:ExecOnRemove(m,o)o=nil local p={}local q=false for r,s in pairs(self._entitiesUpdated)do if(s~=r.archetype)then q=true p[r]=s end end self._entitiesUpdated={}for r,s in pairs(self._entitiesCreated)do q=true p[r]=g.EMPTY r.isAlive=true self._repository:Insert(r)end self._entitiesCreated={}if q then self._executor:ExecOnExitEnter(m,p)p=nil end end end)end function j:Destroy()if self._loopCancel then self._loopCancel()self._loopCancel=nil end if self._onChangeArchetypeEvent then self._onChangeArchetypeEvent:Destroy()self._onChangeArchetypeEvent=nil end self._repository=nil if self._systems then for k,l in pairs(self._systems)do l:Destroy()end self._systems=nil end self._timer=nil self._ExecPlan=nil self._entitiesCreated=nil self._entitiesUpdated=nil self._entitiesRemoved=nil setmetatable(self,nil)end function j:_OnChangeArchetype(k,l,m)if k.isAlive then if self._entitiesUpdated[k]==nil then self._dirty=true self._entitiesUpdated[k]=l end self._repository:Update(k)k.version=self.version end end return j end return c("ECS")