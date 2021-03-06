<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/jsp/include.jsp" %>
<c:set var="basePath" value="${pageContext.servletContext.contextPath }"/>
<div id="add" class="main-container">
</div>
<div id="edit" class="main-container">
</div>
<div class="main-container" id="mainContentInner">
    <div class="page-content">
        <div class="row">
            <div class="col-xs-12">
                <div class="col-xs-12" id="OperPanel">

                </div>

                <div class="row">
                    <table id="zkMediaSourceTable" class="table table-striped table-bordered table-hover"
                           style="text-align: left;width:100%">
                        <thead>
                        <tr>
                            <td>ID</td>
                            <td>Zk集群名称</td>
                            <td>数据源类型</td>
                            <td>ip地址</td>
                            <td>创建时间</td>
                            <td>操作</td>
                        </tr>
                        </thead>
                    </table>
                </div>

            </div>
        </div>
        <!-- /.page-content -->

    </div>
</div>
<script type="text/javascript">
    var zkListMyTable;
    $(".chosen-select").chosen();

    getButtons([{
        code: "002004002",
        html: '<div class="pull-left tableTools-container" style="padding-top: 10px;">' +
        '<p> <button class="btn btn-sm btn-info" onclick="toAdd();">新增</button> </p>' +
        '</div>'
    }], $("#OperPanel"));

    zkListMyTable = $('#zkMediaSourceTable').DataTable({
        "bAutoWidth": true,
        serverSide: true,//开启服务器模式:启用服务器分页
        paging: true,//是否分页
        "ajax": {
            "url": "${basePath}/zk/initZk",
            "data": function (d) {
                return JSON.stringify(d);
            },
            "dataType": 'json',
            "contentType": 'application/json',
            "type": 'POST'
        },
        "columns": [

            {"data": "id"},
            {"data": "name"},
            {"data": "zkMediaSrcParameter.mediaSourceType"},
            {"data": "zkMediaSrcParameter.servers"},
            {
                "data": "createTime",
                "bSortable": false,
                "sWidth": "20%",
                "fnCreatedCell": function (nTd, sData, oData, iRow, iCol) {
                    var time = formatTs(oData.createTime);
                    $(nTd).html(time);
                }
            },
            {
                "data": "id",
                "bSortable": false,
                "sWidth": "10%",
                "fnCreatedCell": function (nTd, sData, oData, iRow, iCol) {

                    getButtons([
                        {
                            code: '002004004',
                            html: function () {
                                var str;
                                str = "<div class='radio'>" +
                                "<a href='javascript:toEdit(" + oData.id + ")' class='blue'  title='修改'>" +
                                "<i class='ace-icon fa fa-pencil bigger-130'></i>" + "</a>" +
                                "</div> &nbsp; &nbsp;"
                                return str;
                            }
                        },
                        {
                            code: '002004006',
                            html: function () {
                                var str;
                                str = "<div class='radio'>" +
                                "<a href='javascript:doDelete(" + oData.id + ")' class='red'  title='删除'>" +
                                "<i class='ace-icon fa fa-trash-o bigger-130'></i>" + "</a>" +
                                "</div> &nbsp; &nbsp;"
                                return str;
                            }
                        },
                        {
                            code: '002004007',
                            html: function () {
                                var str;
                                str = "<div class='radio'>" +
                                "<a href='javascript:checkDataSource(" + oData.id + ")' class='green'  title='验证'>" +
                                "<i class='ace-icon fa fa-hand-o-up bigger-130'></i>" + "</a>" +
                                "</div> &nbsp; &nbsp;"
                                return str;
                            }
                        },
                        {
                            code: '002004008',
                            html: function () {
                                var str;
                                str = "<div class='radio'>" +
                                "<a href='javascript:toReloadDB(" + oData.id + ")' class='green'  title='DBReload'>" +
                                "<i class='ace-icon fa fa-refresh bigger-130'></i>" + "</a>" +
                                "</div> &nbsp; &nbsp;"
                                return str;
                            }
                        }
                    ], $(nTd));

                }
            }
        ]
    });

    function toAdd() {
        reset();//每次必须先reset，把已开界面资源清理掉
        $("#add").load("${basePath}/zk/toAdd?random=" + Math.random());
        $("#add").show();
        $("#mainContentInner").hide();

    }
    function toEdit(id) {
        reset();//每次必须先reset，把已开界面资源清理掉
        $("#edit").load("${basePath}/zk/toEdit?id=" + id + "&random=" + Math.random());
        $("#edit").show();
        $("#mainContentInner").hide();

    }

    function reset() {
        $("#add").empty();
        $("#edit").empty();
    }

    function doDelete(id) {
        if (confirm("确定要删除数据吗？")) {
            $.ajax({
                type: "post",
                url: "${basePath}/zk/doDelete?id=" + id,
                dataType: "json",
                async: false,
                error: function (xhr, status, err) {
                    alert(err);
                },
                success: function (data) {
                    if (data == "success") {
                        alert("删除成功！");
                        zkListMyTable.ajax.reload();
                    } else {
                        alert(data);
                    }
                }
            });
        }
    }

    function checkDataSource(id) {
        if (id == undefined) {
            alert("请选择要验证的Zk数据源!");
            return false;
        }

        $.ajax({
            type: "post",
            url: "${basePath}/zk/checkZk?id=" + id,
            dataType: "json",
            async: false,
            error: function (xhr, status, err) {
                alert(err);
            },
            success: function (data) {
                if (data == "success") {
                    alert("验证成功!");
                } else {
                    alert(data);
                }
            }
        });
    }

    function toReloadDB(id) {
        $.ajax({
            type: "post",
            url: "${basePath}/zk/toReloadDB?mediaSourceId=" + id,
            dataType: "json",
            async: false,
            error: function (xhr, status, err) {
                alert(err);
            },
            success: function (data) {
                if (data == "success") {
                    alert("数据源Reload成功!");
                } else {
                    alert(data);
                }
            }
        });
    }
</script>