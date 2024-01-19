using Microsoft.AspNetCore.Mvc;
using PedidosApi.Application.Dtos;
using PedidosApi.Application.Interfaces;
using System.Net;

namespace PedidosApi.Services.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PedidosController : ControllerBase
    {
        private readonly IPedidoAppService? _pedidoAppService;

        public PedidosController(IPedidoAppService? pedidoAppService)
        {
            _pedidoAppService = pedidoAppService;
        }

        [HttpPost("criar")]
        [ProducesResponseType(typeof(DadosPedidoDto), (int)HttpStatusCode.Created)]
        public async Task<IActionResult> PostAsync([FromBody] CriarPedidoDto criarPedidoDto)
        {
            var result = await this._pedidoAppService.Criar(criarPedidoDto);

            return StatusCode((int)HttpStatusCode.Created, result);
        }

        [HttpGet("consultar/{codigoPedido}")]
        [ProducesResponseType(typeof(DadosPedidoDto), (int)HttpStatusCode.OK)]
        public async Task<IActionResult> Get(Guid codigoPedido)
        {
            var result = await _pedidoAppService.Consultar(codigoPedido);
            return StatusCode((int)HttpStatusCode.OK, result);
        }
    }
}
