using CIR.Common.Data;
using CIR.Common.Enums;
using CIR.Common.Helper;
using CIR.Core.Entities;
using CIR.Core.Entities.Users;
using CIR.Core.Entities.Utilities;
using CIR.Core.Interfaces.Users;
using CIR.Core.ViewModel.Users;
using Dapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Data;

namespace CIR.Data.Data.Users
{
    public class RolesRepository : ControllerBase, IRolesRepository
    {
        #region PROPERTIES
        private readonly CIRDbContext cIRDbContext;
        #endregion

        #region CONSTRUCTOR
        public RolesRepository(CIRDbContext context)
        {
            cIRDbContext = context ??
                throw new ArgumentNullException(nameof(context));
        }
        #endregion

        #region Methods

        /// <summary>
        /// This method return get roles list
        /// </summary>
        /// <returns></returns>
        public async Task<IActionResult> GetAllRoles()
        {
            try
            {
                List<RoleModel> roleList;
                using (DbConnection dbConnection = new DbConnection())
                {
                    using (var connection = dbConnection.Connection)
                    {
                        roleList = connection.Query<RoleModel>("spGetAllRoles", null, commandType: CommandType.StoredProcedure).ToList();
                    }
                }
                if (roleList.Count == 0)
                {
                    return new JsonResult(new CustomResponse<string>() { StatusCode = (int)HttpStatusCodesAndMessages.HttpStatus.NotFound, Result = false, Message = string.Format(SystemMessages.msgNotFound, "Roles") });
                }
                return new JsonResult(new CustomResponse<List<RoleModel>>() { StatusCode = (int)HttpStatusCodesAndMessages.HttpStatus.Success, Result = true, Message = HttpStatusCodesAndMessages.HttpStatus.Success.GetDescriptionAttribute(), Data = roleList });
            }
            catch
            {
                return new JsonResult(new CustomResponse<Exception>() { StatusCode = (int)HttpStatusCodesAndMessages.HttpStatus.InternalServerError, Result = false, Message = SystemMessages.msgSomethingWentWrong });
            }
        }

        /// <summary>
		/// This method retuns filtered role list using LINQ
		/// </summary>
		/// <param name="displayLength"> how many row/data we want to fetch(for pagination) </param>
		/// <param name="displayStart"> from which row we want to fetch(for pagination) </param>
		/// <param name="sortCol"> name of column which we want to sort</param>
		/// <param name="search"> word that we want to search in user table </param>
		/// <param name="sortAscending"> 'asc' or 'desc' direction for sort </param>
		/// <returns> filtered list of roles </returns>
        public async Task<IActionResult> GetRoles(int displayLength, int displayStart, string? sortCol, string? search, bool sortAscending = true)
        {
            RolesModel roles = new();

            if (string.IsNullOrEmpty(sortCol))
            {
                sortCol = "Id";
            }
            try
            {
                List<RoleViewModel> roleViewModels;
                using (DbConnection dbConnection = new DbConnection())
                {
                    using (var connection = dbConnection.Connection)
                    {
                        DynamicParameters parameters = new DynamicParameters();
                        parameters.Add("@DisplayLength", displayLength);
                        parameters.Add("@DisplayStart", displayStart);
                        parameters.Add("@SortCol", sortCol);
                        parameters.Add("@Search", search);
                        parameters.Add("@SortDir", sortAscending);
                        roleViewModels = connection.Query<RoleViewModel>("spGetRoles", parameters, commandType: CommandType.StoredProcedure).ToList();
                    }
                }
                if (roleViewModels.Count > 0)
                {
                    roleViewModels = roleViewModels.ToList();
                    roles.Count = roleViewModels[0].TotalCount;
                    roles.RolesList = roleViewModels;
                }
                else
                {
                    roles.Count = 0;
                    roles.RolesList = roleViewModels;
                }
                return new JsonResult(new CustomResponse<RolesModel>() { StatusCode = (int)HttpStatusCodesAndMessages.HttpStatus.Success, Result = true, Message = HttpStatusCodesAndMessages.HttpStatus.Success.GetDescriptionAttribute(), Data = roles });
            }
            catch
            {
                return new JsonResult(new CustomResponse<Exception>() { StatusCode = (int)HttpStatusCodesAndMessages.HttpStatus.InternalServerError, Result = false, Message = SystemMessages.msgSomethingWentWrong });
            }
        }
        public async Task<IActionResult> GetLanguagesListByRole()
        {
            try
            {
                List<Culture> cultureList;
                using (DbConnection dbConnection = new DbConnection())
                {
                    using (var connection = dbConnection.Connection)
                    {
                        cultureList = connection.Query<Culture>("spGetLanguagesListByRole", null, commandType: CommandType.StoredProcedure).ToList();
                    }
                }
                if (cultureList.Count == 0)
                {
                    return new JsonResult(new CustomResponse<string>() { StatusCode = (int)HttpStatusCodesAndMessages.HttpStatus.NotFound, Result = false, Message = string.Format(SystemMessages.msgNotFound, "Cultures") });
                }
                return new JsonResult(new CustomResponse<List<Culture>>() { StatusCode = (int)HttpStatusCodesAndMessages.HttpStatus.Success, Result = true, Message = HttpStatusCodesAndMessages.HttpStatus.Success.GetDescriptionAttribute(), Data = cultureList });
            }
            catch
            {
                return new JsonResult(new CustomResponse<Exception>() { StatusCode = (int)HttpStatusCodesAndMessages.HttpStatus.InternalServerError, Result = false, Message = SystemMessages.msgSomethingWentWrong });
            }
        }
        public async Task<IActionResult> GetRolePrivilegesList()
        {
            try
            {
                List<RolePrivilegesMModel> rolePrivilegesses = new();
                using (DbConnection dbConnection = new DbConnection())
                {
                    using (var connection = dbConnection.Connection)
                    {
                        Array enumValueArray = Enum.GetValues(typeof(RolePriviledgesEnums));
                        foreach (int enumValue in enumValueArray)
                        {
                            rolePrivilegesses.Add(new RolePrivilegesMModel()
                            {
                                Name = Enum.GetName(typeof(RolePriviledgesEnums), enumValue),
                                DisplayName = ((RolePriviledgesEnums)enumValue).GetDescriptionAttribute(),
                                Id = enumValue
                            });
                        }
                    }
                }
                if (rolePrivilegesses.Count == 0)
                {
                    return new JsonResult(new CustomResponse<string>() { StatusCode = (int)HttpStatusCodesAndMessages.HttpStatus.NotFound, Result = false, Message = string.Format(SystemMessages.msgNotFound, "Role Privileges") });
                }
                return new JsonResult(new CustomResponse<List<RolePrivilegesMModel>>() { StatusCode = (int)HttpStatusCodesAndMessages.HttpStatus.Success, Result = true, Message = HttpStatusCodesAndMessages.HttpStatus.Success.GetDescriptionAttribute(), Data = rolePrivilegesses });
            }
            catch
            {
                return new JsonResult(new CustomResponse<Exception>() { StatusCode = (int)HttpStatusCodesAndMessages.HttpStatus.InternalServerError, Result = false, Message = SystemMessages.msgSomethingWentWrong });
            }
        }

        public async Task<IActionResult> GetSubSiteList()
        {
            try
            {
                List<SubSite> subsitesList;
                using (DbConnection dbConnection = new DbConnection())
                {
                    using (var connection = dbConnection.Connection)
                    {
                        subsitesList = connection.Query<SubSite>("spGetSubSites", null, commandType: CommandType.StoredProcedure).ToList();
                    }
                }
                if (subsitesList.Count == 0)
                {
                    return new JsonResult(new CustomResponse<string>() { StatusCode = (int)HttpStatusCodesAndMessages.HttpStatus.NotFound, Result = false, Message = string.Format(SystemMessages.msgNotFound, "SubSite") });
                }
                return new JsonResult(new CustomResponse<List<SubSite>>() { StatusCode = (int)HttpStatusCodesAndMessages.HttpStatus.Success, Result = true, Message = HttpStatusCodesAndMessages.HttpStatus.Success.GetDescriptionAttribute(), Data = subsitesList });
            }
            catch
            {
                return new JsonResult(new CustomResponse<Exception>() { StatusCode = (int)HttpStatusCodesAndMessages.HttpStatus.InternalServerError, Result = false, Message = SystemMessages.msgSomethingWentWrong });
            }
        }
        public async Task<Boolean> RoleExists(string roleName, long id)
        {
            var result = false;
            using (DbConnection dbConnection = new DbConnection())
            {
                using (var connection = dbConnection.Connection)
                {
                    DynamicParameters parameters = new DynamicParameters();
                    parameters.Add("@Id", id);
                    parameters.Add("@Name", roleName);
                    result = await Task.FromResult(Convert.ToBoolean(connection.ExecuteScalar("spRoleExists", parameters, commandType: CommandType.StoredProcedure)));
                }
                return result;
            }
        }

        /// <summary>
		/// This method takes a add or update role
		/// </summary>
		/// <param name="roles"></param>
		/// <returns></returns>
        public async Task<IActionResult> CreateOrUpdateRole(RolePermissionModel roles)
        {
            try
            {
                if (roles.Name == "" || roles.WrongLoginAttempts == 0)
                {
                    return new JsonResult(new CustomResponse<string>() { StatusCode = (int)HttpStatusCodesAndMessages.HttpStatus.BadRequest, Result = false, Message = SystemMessages.msgEnterValidData });
                }

                if (roles.Id == 0)
                {
                    Roles newRole = new()
                    {
                        Name = roles.Name,
                        AllPermissions = roles.AllPermissions,
                        CreatedOn = DateTime.Now,
                        Description = roles.Description,
                        WrongLoginAttempts = roles.WrongLoginAttempts
                    };

                    cIRDbContext.Roles.Add(newRole);
                    await cIRDbContext.SaveChangesAsync();

                    var roleDetails = cIRDbContext.Roles.Where(c => c.Name == roles.Name).FirstOrDefault();
                    if (!roleDetails.AllPermissions)
                    {
                        foreach (var role in roles.Roles)
                        {
                            RoleGrouping roleGrouping = new()
                            {
                                RoleId = roleDetails.Id
                            };
                            cIRDbContext.RolesGroupings.Add(roleGrouping);
                            await cIRDbContext.SaveChangesAsync();

                            var roleGroupingDetail = cIRDbContext.RolesGroupings.Where(c => c.RoleId == roleDetails.Id).OrderByDescending(c => c.Id).FirstOrDefault();
                            if (roleGroupingDetail != null)
                            {
                                foreach (var item in role.site)
                                {
                                    RoleGrouping2SubSite roleGrouping2SubSite = new RoleGrouping2SubSite()
                                    {
                                        RoleGroupingId = roleGroupingDetail.Id,
                                        SubSiteId = item.SiteId
                                    };
                                    await cIRDbContext.RoleGrouping2SubSites.AddAsync(roleGrouping2SubSite);
                                    await cIRDbContext.SaveChangesAsync();
                                    foreach (var items in item.Languages)
                                    {
                                        RoleGrouping2Culture roleGrouping2Culture = new RoleGrouping2Culture()
                                        {
                                            RoleGroupingId = roleGroupingDetail.Id,
                                            CultureLcid = items.CultureId
                                        };
                                        if (!cIRDbContext.RoleGrouping2Cultures.Any(c => c.RoleGroupingId == roleGrouping2Culture.RoleGroupingId && c.CultureLcid == roleGrouping2Culture.CultureLcid))
                                        {
                                            await cIRDbContext.RoleGrouping2Cultures.AddAsync(roleGrouping2Culture);
                                            await cIRDbContext.SaveChangesAsync();
                                        }

                                        foreach (var subitem in items.Privileges)
                                        {

                                            RoleGrouping2Permission roleGrouping2Permission = new RoleGrouping2Permission()
                                            {
                                                RoleGroupingId = roleGroupingDetail.Id,
                                                PermissionEnumId = subitem.PrivilegesId
                                            };
                                            if (!cIRDbContext.RoleGrouping2Permissions.Any(c => c.RoleGroupingId == roleGrouping2Permission.RoleGroupingId && c.PermissionEnumId == roleGrouping2Permission.PermissionEnumId))
                                            {
                                                await cIRDbContext.RoleGrouping2Permissions.AddAsync(roleGrouping2Permission);
                                                await cIRDbContext.SaveChangesAsync();
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if (roles.Name != null)
                    {
                        return new JsonResult(new CustomResponse<string>() { StatusCode = (int)HttpStatusCodesAndMessages.HttpStatus.Saved, Result = true, Message = string.Format(SystemMessages.msgDataSavedSuccessfully, "Role") });
                    }
                }
                else
                {
                    var rolesDetails = from var in cIRDbContext.Roles
                                       where var.Id == roles.Id
                                       select var.CreatedOn;

                    Roles updaterole = new()
                    {
                        Id = roles.Id,
                        Name = roles.Name,
                        AllPermissions = roles.AllPermissions,
                        CreatedOn = rolesDetails.FirstOrDefault(),
                        LastEditedOn = DateTime.Now,
                        Description = roles.Description,
                        WrongLoginAttempts = roles.WrongLoginAttempts
                    };
                    cIRDbContext.Entry(updaterole).State = EntityState.Modified;
                    await cIRDbContext.SaveChangesAsync();

                    var roleDetails = cIRDbContext.Roles.Where(c => c.Id == roles.Id).FirstOrDefault();
                    if (!roleDetails.AllPermissions)
                    {
                        foreach (var role in roles.Roles)
                        {
                            if (role.groupId != 0)
                            {
                                var roleGroupingDetail = cIRDbContext.RolesGroupings.Where(c => c.Id == role.groupId && c.RoleId == roleDetails.Id).FirstOrDefault();
                                if (roleGroupingDetail != null)
                                {
                                    cIRDbContext.RoleGrouping2SubSites.RemoveRange(cIRDbContext.RoleGrouping2SubSites.Where(x => x.RoleGroupingId == roleGroupingDetail.Id));
                                    await cIRDbContext.SaveChangesAsync();
                                    cIRDbContext.RoleGrouping2Cultures.RemoveRange(cIRDbContext.RoleGrouping2Cultures.Where(x => x.RoleGroupingId == roleGroupingDetail.Id));
                                    await cIRDbContext.SaveChangesAsync();
                                    cIRDbContext.RoleGrouping2Permissions.RemoveRange(cIRDbContext.RoleGrouping2Permissions.Where(x => x.RoleGroupingId == roleGroupingDetail.Id));
                                    await cIRDbContext.SaveChangesAsync();

                                    foreach (var item in role.site)
                                    {

                                        RoleGrouping2SubSite roleGrouping2SubSite = new RoleGrouping2SubSite()
                                        {
                                            RoleGroupingId = roleGroupingDetail.Id,
                                            SubSiteId = item.SiteId
                                        };
                                        cIRDbContext.RoleGrouping2SubSites.Add(roleGrouping2SubSite);
                                        await cIRDbContext.SaveChangesAsync();
                                        foreach (var items in item.Languages)
                                        {
                                            RoleGrouping2Culture roleGrouping2Culture = new RoleGrouping2Culture()
                                            {
                                                RoleGroupingId = roleGroupingDetail.Id,
                                                CultureLcid = items.CultureId
                                            };
                                            if (!cIRDbContext.RoleGrouping2Cultures.Any(c => c.RoleGroupingId == roleGrouping2Culture.RoleGroupingId && c.CultureLcid == roleGrouping2Culture.CultureLcid))
                                            {
                                                await cIRDbContext.RoleGrouping2Cultures.AddAsync(roleGrouping2Culture);
                                                await cIRDbContext.SaveChangesAsync();
                                            }

                                            foreach (var subitem in items.Privileges)
                                            {

                                                RoleGrouping2Permission roleGrouping2Permission = new RoleGrouping2Permission()
                                                {
                                                    RoleGroupingId = roleGroupingDetail.Id,
                                                    PermissionEnumId = subitem.PrivilegesId
                                                };
                                                if (!cIRDbContext.RoleGrouping2Permissions.Any(c => c.RoleGroupingId == roleGrouping2Permission.RoleGroupingId && c.PermissionEnumId == roleGrouping2Permission.PermissionEnumId))
                                                {
                                                    cIRDbContext.RoleGrouping2Permissions.Add(roleGrouping2Permission);
                                                    await cIRDbContext.SaveChangesAsync();
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            else
                            {
                                RoleGrouping roleGrouping = new()
                                {
                                    RoleId = roleDetails.Id
                                };
                                cIRDbContext.RolesGroupings.Add(roleGrouping);
                                await cIRDbContext.SaveChangesAsync();

                                var roleGroupingDetail = cIRDbContext.RolesGroupings.Where(c => c.RoleId == roleDetails.Id).OrderByDescending(c => c.Id).FirstOrDefault();
                                if (roleGroupingDetail != null)
                                {
                                    foreach (var item in role.site)
                                    {
                                        RoleGrouping2SubSite roleGrouping2SubSite = new RoleGrouping2SubSite()
                                        {
                                            RoleGroupingId = roleGroupingDetail.Id,
                                            SubSiteId = item.SiteId
                                        };
                                        await cIRDbContext.RoleGrouping2SubSites.AddAsync(roleGrouping2SubSite);
                                        await cIRDbContext.SaveChangesAsync();
                                        foreach (var items in item.Languages)
                                        {
                                            RoleGrouping2Culture roleGrouping2Culture = new RoleGrouping2Culture()
                                            {
                                                RoleGroupingId = roleGroupingDetail.Id,
                                                CultureLcid = items.CultureId
                                            };
                                            if (!cIRDbContext.RoleGrouping2Cultures.Any(c => c.RoleGroupingId == roleGrouping2Culture.RoleGroupingId && c.CultureLcid == roleGrouping2Culture.CultureLcid))
                                            {
                                                await cIRDbContext.RoleGrouping2Cultures.AddAsync(roleGrouping2Culture);
                                                await cIRDbContext.SaveChangesAsync();
                                            }

                                            foreach (var subitem in items.Privileges)
                                            {

                                                RoleGrouping2Permission roleGrouping2Permission = new RoleGrouping2Permission()
                                                {
                                                    RoleGroupingId = roleGroupingDetail.Id,
                                                    PermissionEnumId = subitem.PrivilegesId
                                                };
                                                if (!cIRDbContext.RoleGrouping2Permissions.Any(c => c.RoleGroupingId == roleGrouping2Permission.RoleGroupingId && c.PermissionEnumId == roleGrouping2Permission.PermissionEnumId))
                                                {
                                                    await cIRDbContext.RoleGrouping2Permissions.AddAsync(roleGrouping2Permission);
                                                    await cIRDbContext.SaveChangesAsync();
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else
                    {
                        var roleGroupingData = cIRDbContext.RolesGroupings.Where(r => r.RoleId == roleDetails.Id).ToList();
                        foreach (var item in roleGroupingData)
                        {
                            cIRDbContext.RolesGroupings.Remove(item);
                            await cIRDbContext.SaveChangesAsync();
                        }
                    }
                    if (roles.Id != 0)
                    {
                        return new JsonResult(new CustomResponse<string>() { StatusCode = (int)HttpStatusCodesAndMessages.HttpStatus.Saved, Result = true, Message = string.Format(SystemMessages.msgDataUpdatedSuccessfully, "Role") });
                    }
                }
                return new JsonResult(new CustomResponse<string>() { StatusCode = (int)HttpStatusCodesAndMessages.HttpStatus.UnprocessableEntity, Result = false, Message = string.Format(SystemMessages.msgSavingDataError, "Roles") });
            }
            catch
            {
                return new JsonResult(new CustomResponse<Exception>() { StatusCode = (int)HttpStatusCodesAndMessages.HttpStatus.InternalServerError, Result = false, Message = SystemMessages.msgSomethingWentWrong });
            }
        }

        /// <summary>
        /// This method takes a get role detail by roleid
        /// </summary>
        /// <param name="roleId"></param>
        /// <returns></returns>
        public async Task<IActionResult> GetRoleDetailById(long roleId)
        {
            try
            {
                RolePermissionModel rolePermissionModel;
                var dictionaryobj = new Dictionary<string, object>
                {
                    { "roleId", roleId }
                };

                DataTable roleDetailDatatable = SQLHelper.ExecuteSqlQueryWithParams("spGetRoleDetailByRoleId", dictionaryobj);
                if (roleDetailDatatable.Rows.Count > 0)
                {
                    rolePermissionModel = new();
                    var listData = SQLHelper.ConvertToGenericModelList<RolePermissionModel>(roleDetailDatatable);
                    rolePermissionModel.Id = listData[0].Id;
                    rolePermissionModel.Name = listData[0].Name;
                    rolePermissionModel.Description = listData[0].Description;
                    rolePermissionModel.WrongLoginAttempts = listData[0].WrongLoginAttempts;
                    rolePermissionModel.AllPermissions = listData[0].AllPermissions;
                    if (!rolePermissionModel.AllPermissions)
                    {
                        rolePermissionModel.Roles = RolesTreeViewList.GetRolesListData(roleDetailDatatable);
                    }
                    else
                    {
                        rolePermissionModel.Roles = null;
                    }
                    if (rolePermissionModel == null)
                    {
                        return new JsonResult(new CustomResponse<string>() { StatusCode = (int)HttpStatusCodesAndMessages.HttpStatus.NotFound, Result = false, Message = string.Format(SystemMessages.msgDataNotExists, "Role") });
                    }
                    return new JsonResult(new CustomResponse<RolePermissionModel>() { StatusCode = (int)HttpStatusCodesAndMessages.HttpStatus.Success, Result = true, Message = HttpStatusCodesAndMessages.HttpStatus.Success.GetDescriptionAttribute(), Data = rolePermissionModel });
                }
                else
                {
                    return new JsonResult(new CustomResponse<string>() { StatusCode = (int)HttpStatusCodesAndMessages.HttpStatus.NotFound, Result = false, Message = string.Format(SystemMessages.msgDataNotExists, "Role") });
                }
            }
            catch
            {
                return new JsonResult(new CustomResponse<Exception>() { StatusCode = (int)HttpStatusCodesAndMessages.HttpStatus.InternalServerError, Result = false, Message = SystemMessages.msgSomethingWentWrong });
            }
        }

        /// <summary>
        /// This method takes a delete role and role permission
        /// </summary>
        /// <param name="roleId"></param>
        /// <returns></returns>
        public async Task<IActionResult> DeleteRoles(long roleId)
        {
            try
            {
                if (cIRDbContext.Users.Any(x => x.RoleId == roleId))
                {
                    return new JsonResult(new CustomResponse<string>() { StatusCode = (int)HttpStatusCodesAndMessages.HttpStatus.BadRequest, Result = false, Message = SystemMessages.msgCannotRemoveRecord });
                }
                else
                {
                    var result = 0;
                    using (DbConnection dbConnection = new DbConnection())
                    {
                        using (var connection = dbConnection.Connection)
                        {
                            DynamicParameters parameters = new DynamicParameters();
                            parameters.Add("@RoleId", roleId);
                            result = await Task.FromResult(connection.Execute("spDeleteRoles", parameters, commandType: CommandType.StoredProcedure));
                        }
                    }
                    if (result != 0)
                    {
                        return new JsonResult(new CustomResponse<string>() { StatusCode = (int)HttpStatusCodesAndMessages.HttpStatus.Success, Result = true, Message = string.Format(SystemMessages.msgDataDeletedSuccessfully, "Role") });
                    }
                }
                return new JsonResult(new CustomResponse<string>() { StatusCode = (int)HttpStatusCodesAndMessages.HttpStatus.NotFound, Result = false, Message = string.Format(SystemMessages.msgDataNotExists, "Role") });
            }
            catch
            {
                return new JsonResult(new CustomResponse<Exception>() { StatusCode = (int)HttpStatusCodesAndMessages.HttpStatus.InternalServerError, Result = false, Message = SystemMessages.msgSomethingWentWrong });
            }
        }
        /// <summary>
        /// This method takes a remove section role id wise
        /// </summary>
        /// <param name="groupId"></param>
        /// <returns></returns>
        public async Task<IActionResult> RemoveSection(long groupId)
        {
            try
            {
                if (groupId > 0)
                {
                    var result = 0;
                    using (DbConnection dbConnection = new DbConnection())
                    {
                        using (var connection = dbConnection.Connection)
                        {
                            DynamicParameters parameters = new DynamicParameters();
                            parameters.Add("@GroupId", groupId);
                            result = await Task.FromResult(connection.Execute("spRemoveSection", parameters, commandType: CommandType.StoredProcedure));
                        }
                    }
                    if (result != 0)
                    {
                        return new JsonResult(new CustomResponse<string>() { StatusCode = (int)HttpStatusCodesAndMessages.HttpStatus.Success, Result = true, Message = string.Format(SystemMessages.msgDataDeletedSuccessfully, "Section") });
                    }
                }
                return new JsonResult(new CustomResponse<string>() { StatusCode = (int)HttpStatusCodesAndMessages.HttpStatus.BadRequest, Result = false, Message = string.Format(SystemMessages.msgDataNotExists, "Selected Group") });
            }
            catch
            {
                return new JsonResult(new CustomResponse<Exception>() { StatusCode = (int)HttpStatusCodesAndMessages.HttpStatus.InternalServerError, Result = false, Message = SystemMessages.msgSomethingWentWrong });
            }
        }

        #endregion
    }
}