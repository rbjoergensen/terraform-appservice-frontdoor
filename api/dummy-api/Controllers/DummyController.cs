using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using Microsoft.Extensions.Configuration;

namespace dummy_api.Controllers
{
    [ApiController]
    [Route("api/v1")]
    public class DummyController : ControllerBase
    {
        private readonly IConfiguration configuration;

        public DummyController(IConfiguration iConfig)
        {
            configuration = iConfig;
        }

        [HttpGet]
        [Route("one")]
        public List<Dummy> One()
        {
            var dummy = configuration.GetSection("Dummy").Value;

            return new List<Dummy> {
                new Dummy{
                    Message = dummy
                }
            };
        }

        [HttpGet]
        [Route("two")]
        public List<Dummy> Two()
        {
            var dummy = configuration.GetSection("Dummy").Value;

            return new List<Dummy> {
                new Dummy{
                    Message = dummy
                }
            };
        }

        [HttpGet]
        [Route("three")]
        public List<Dummy> Three()
        {
            var dummy = configuration.GetSection("Dummy").Value;

            return new List<Dummy> {
                new Dummy{
                    Message = dummy
                }
            };
        }

    }
}
