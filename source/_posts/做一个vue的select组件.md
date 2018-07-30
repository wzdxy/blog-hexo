---
title: 做一个vue的select组件
date: 2017-07-06 14:11:11
tags: 
- vue
- 前端
permalink: vue-select-demo
---

组件接收两个 `prop` 一个是选中的值 `value`, 和父级的数据绑定, 用 `.sync` 修饰, 另一个是选项数组
 `option`, 同样用 `.sync` 修饰.


```js
<div id="app">
  <p>页面值:`value1`</p><p>页面值:`value2`</p>
  <input type="number" v-model="value1">
  <input type="number" v-model="value2">
  <v-s :value.sync="value1" :options="options1"></v-s>
  <v-s :value.sync="value2" :options.sync="options2"></v-s>
  <button @click="addOpt(1)">+1</button>
  <button @click="addOpt(2)">+2</button>
</div>
```
<!-- more -->

```js
//怎么去掉右边选择的js框架啊 →→→→→→→→→→→→→→→→
Vue.component('v-s',{
	template:'<div id="v-s"><div class="selected-div" @click="toggle"><span class="selected-span" v-for="(opt,idx) in selected">`opt`.`name`</span></div><ul v-show="open" class="options-list dropdown-menu inner"><li v-bind:class="{selectedItem:opt.selected}" class="option" v-for="(opt,idx) in options" @click="select(idx)">`opt`.`name`</li></ul></div>',
	data:function(){
  	return {
      open:false,
      //propValue:this.value
    }
  },
  props:['value','options','size'],
  methods:{
  	toggle:function(param){
    	if(param==='show')this.open=true;
      else if(param==='hide')this.open=false;
      else this.open=!this.open;
    },
    select:function(idx){
    	this.open=false;
      for(let i=0,m=this.options.length;i<m;i++){
      	this.options[i].selected=(i===idx);
        if(i===idx){
        	this.$set(this.options[i],'selected',true);
          this.$emit('update:value',this.options[i].value);
        }else{
        	this.$delete(this.options[i],'selected');
        }
      }
    },
    setVal:function(val){
    	if(!val)return false;
      for(let i=0,m=this.options.length;i<m;i++){
      	if(this.options[i].value==val){
        	this.select(i);
          return i;
        }
      }
      return -1
    }
  },
  computed:{
  	selected:function(){
    	return this.options.filter(function(item){return item.selected===true;});
    },
    val:function(){
    	return this.selected.length>0?this.selected[0].value:null;
    },    
  },
  watch:{
  	val:function(val){
    	this.$emit('update:value', val);
    },
    value:function(val){
    	this.setVal(val);
    }
  },
  beforeCreate:function(){
  	console.log('cc');    
    document.body.addEventListener('click',function(e){    	      
			if(Array.prototype.indexOf.call(e.target.classList,'selected-div')==-1 && Array.prototype.indexOf.call(e.target.classList,'selected-span')==-1){
      	this.toggle('hide');      
      }
    }.bind(this));
  }
})

vm=new Vue({
	el:'#app',
  data:{
  	options1:[
    	{name:'a',value:0},{name:'b',value:1},{name:'c',value:2}
    ],
    options2:[
    	{name:'aa',value:5},{name:'bb',value:6},{name:'cc',value:7}
    ],
    value1:0,
    value2:6,
  },
  methods:{
  	addOpt:function(i){
    	if(i==1)this.options1.push({value:new Date().getTime(),name:new Date()});
      if(i==2)this.options2.push({value:new Date().getTime(),name:new Date()});
    }
  }
})
```

<script async src="//jsfiddle.net/wzdxy/ty7unuk2/embed/"></script>